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

local function is_acceptable_weather_param(value, attr, config)
	local min = config.conditions["min_" .. attr] or -10000
	local max = config.conditions["max_" .. attr] or  math.huge
	minetest.log(attr .. ": " .. value .. " <=> " .. min .. "," .. max)
	return value > min and value <= max
end

function weather_mod.get_weather(pos, wind)
	local params = {}
	params.heat = weather_mod.get_heat(pos)
	params.humidity = weather_mod.get_humidity(pos)
	params.windspeed = vector.length(wind)
	minetest.log(params.heat .. ", " .. params.humidity .. ", " .. params.windspeed)

	local weather
	local priority = -1
	local attributes = { "heat", "humidity", "windspeed" }
	for name, config in pairs(weather_mod.weathers) do
		minetest.log(dump2(priority, "p"))
		if type(priority) ~= "nil" and config.priority < priority then
			minetest.log("skipped " .. name)

		elseif type(config.conditions) == "nil" then
			weather = name
			priority = config.priority
			minetest.log("selected (nil) " .. name)

		else
			local check = true
			for _, attr in ipairs(attributes) do
				if not is_acceptable_weather_param(params[attr], attr, config) then
					check = false
				end
			end
			if check then
				weather = name
				priority = config.priority
				minetest.log("selected " .. name)
			end
		end
	end
	if type(weather) == "nil" then
		minetest.log("error", "[Ultimate Weather] No default weather registered")
	end
	minetest.log(weather)
	return weather
end