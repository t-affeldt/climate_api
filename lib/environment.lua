function weather_mod.get_heat(pos)
	local base = weather_mod.settings.heat;
	local biome = minetest.get_heat(pos)
	local height = math.min(math.max(-pos.y / 15, -10), 10)
	local random = weather_mod.state.heat;
	return (base + biome + height) * random
end

function weather_mod.get_humidity(pos)
	local base = weather_mod.settings.humidity
	local biome = minetest.get_humidity(pos)
	local random = weather_mod.state.humidity;
	return (base + biome) * random
end

function weather_mod.get_climate(pos)
	local climate = {pos = pos}
	climate.heat = weather_mod.get_heat(pos)
	climate.humidity = weather_mod.get_humidity(pos)
	climate.windspeed = vector.length(weather_mod.state.wind)
	return climate
end

local function is_acceptable_weather_param(value, attr, config)
	local min = config.conditions["min_" .. attr] or -math.huge
	local max = config.conditions["max_" .. attr] or  math.huge
	return value > min and value <= max
end

function weather_mod.get_effects(climate)
	local forced_weather = weather_mod.state.current_weather
	if type(forced_weather) ~= nil and forced_weather ~= "auto" then
		return { forced_weather }
	end
	local params = {}
	params.heat = climate.heat
	params.humidity = climate.humidity
	params.windspeed = vector.length(weather_mod.state.wind)
	params.height = climate.pos.y

	local effects = {}
	local attributes = { "heat", "humidity", "windspeed", "height" }
	for name, effect in pairs(weather_mod.weathers) do
		if type(effect.config.conditions) == "nil" then
			table.insert(effects, name)
			goto continue
		end

		for _, attr in ipairs(attributes) do
			if not is_acceptable_weather_param(params[attr], attr, effect.config) then
				goto continue
			end
		end
		table.insert(effects, name)
		::continue::
	end
	minetest.log(dump2(effects, "effects"))
	return effects
end