local trigger = {}

function trigger.get_player_environment(player)
	local ppos = player:get_pos()
	local wind_x = climate_mod.state:get_float("wind_x")
	local wind_z = climate_mod.state:get_float("wind_z")

	local env = {}
	env.player = player
	env.pos = ppos
	env.height = ppos.y
	env.wind = vector.new(wind_x, 0, wind_z)
	env.windspeed = vector.length(env.wind)
	env.heat = climate_api.environment.get_heat(ppos)
	env.humidity = climate_api.environment.get_humidity(ppos)
	env.time = minetest.get_timeofday()
	env.date = minetest.get_day_count()
	return env
end

local function test_condition(condition, env, goal)
	local value = env[condition:sub(5)]
	if condition:sub(1, 4) == "min_" then
		return type(value) ~= "nil" and goal <= value
	elseif condition:sub(1, 4) == "max_" then
		return type(value) ~= "nil" and goal > value
	else
		Minetest.log("warning", "[Climate API] Invalid effect condition")
		return false
	end
end

local function is_weather_active(player, weather, env)
	if climate_mod.forced_weather[weather] ~= nil then
		return climate_mod.forced_weather[weather]
	end
	local config = climate_mod.weathers[weather]
	if type(config.conditions) == "function" then
		return config.conditions(env)
	end
	for condition, goal in pairs(config.conditions) do
		if not test_condition(condition, env, goal) then
			return false
		end
	end
	return true
end

local function get_weather_effects(player, weather_config, env)
	local config = {}
	local effects = {}
	if type(weather_config.effects) == "function" then
		config = weather_config.effects(env)
	else
		config = weather_config.effects
	end
	for effect, value in pairs(config) do
		if type(climate_mod.effects[effect]) ~= "nil" then
			effects[effect] = value
		end
	end
	return effects
end

function trigger.get_active_effects()
	local environments = {}
	for _, player in ipairs(minetest.get_connected_players()) do
		environments[player:get_player_name()] = trigger.get_player_environment(player)
	end

	local effects = {}
	climate_mod.current_weather = {}
	for wname, wconfig in pairs(climate_mod.weathers) do
		for _, player in ipairs(minetest.get_connected_players()) do
			local pname = player:get_player_name()
			local env = environments[pname]
			if is_weather_active(player, wname, env) then
				if type(climate_mod.current_weather[pname]) == "nil" then
					climate_mod.current_weather[pname] = {}
				end
				table.insert(climate_mod.current_weather[pname], wname)
				local player_effects = get_weather_effects(player, wconfig, env)
				for effect, value in pairs(player_effects) do
					if type(effects[effect]) == "nil" then
						effects[effect] = {}
					end
					if type(effects[effect][pname]) == "nil" then
						effects[effect][pname] = {}
					end
					effects[effect][pname][wname] = value
				end
			end
		end
	end
	return effects
end

function trigger.call_handlers(name, effect, prev_effect)
	if effect == nil then effect = {} end
	if prev_effect == nil then prev_effect = {} end

	local starts = {}
	local has_starts = false
	local ticks = {current = {}, prev = {}}
	local has_ticks = false
	local stops = {}
	local has_stops = false

	for player, sources in pairs(effect) do
		if type(prev_effect[player]) ~= "nil" then
			has_ticks = true
			ticks.current[player] = sources
			ticks.prev[player] = prev_effect[player]
			--prev_effect[player] = nil -- remove any found entries
		else
			has_starts = true
			starts[player] = sources
		end
	end

	for player, sources in pairs(prev_effect) do
		if type(effect[player]) == "nil" then
			stops[player] = sources
			has_stops = true
		end
	end

	if has_starts then
		for _, handler in ipairs(climate_mod.effects[name]["start"]) do
			handler(starts)
		end
	end

	if has_ticks then
		for _, handler in ipairs(climate_mod.effects[name]["tick"]) do
			handler(ticks.current, ticks.prev)
		end
	end

	-- remaining table lists ending effects
	if has_stops then
		minetest.log(dump2(name, "AAAAAAAAAAA"))
		for _, handler in ipairs(climate_mod.effects[name]["stop"]) do
			handler(stops)
		end
	end
end

return trigger