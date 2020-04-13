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

local function is_weather_active(player, weather_config, env)
	if type(weather_config.conditions) == "function" then
		return weather_config.conditions(env)
	end
	for condition, goal in pairs(weather_config.conditions) do
		if not test_condition(condition, env, goal) then
			return false
		end
	end
	return true
end

local function get_weather_effects(player, weather_config, env)
	if type(weather_config.effects) == "function" then
		return weather_config.effects(env)
	end
	return weather_config.effects
end

function trigger.get_active_effects()
	local environments = {}
	for _, player in ipairs(minetest.get_connected_players()) do
		environments[player:get_player_name()] = trigger.get_player_environment(player)
	end

	local effects = {}
	for wname, wconfig in pairs(climate_mod.weathers) do
		for _, player in ipairs(minetest.get_connected_players()) do
			local pname = player:get_player_name()
			local env = environments[pname]
			if is_weather_active(player, wconfig, env) then
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

function trigger.call_handlers(name, effect)
	if type(effect) == "nil" then return end
	for _, handler in ipairs(climate_mod.effects[name]["tick"]) do
		handler(effect)
	end
end

return trigger