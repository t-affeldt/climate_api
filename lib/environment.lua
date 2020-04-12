local environment = {}

local function get_heat_time()
	local time = minetest.get_timeofday()
	return climate_api.utility.normalized_cycle(time) * 0.4 + 0.3
end

local function get_heat_calendar()
	-- European heat center in August instead of June
	local day = climate_mod.state:get("time_current_day")
	local progression = ((day + 61) % 365) / 365
	return climate_api.utility.normalized_cycle(progression) * 0.4 + 0.3
end

local function get_heat_height(y)
	return climate_api.utility.rangelim(-y / 15, -10, 10)
end

function environment.get_heat(pos)
	local base = climate_mod.settings.heat
	local biome = minetest.get_heat(pos)
	local height = get_heat_height(pos.y)
	local time = get_heat_time()
	local date = get_heat_calendar()
	local random = climate_mod.state:get_int("heat_random");
	return (base + biome + height) * time * date
end

function environment.get_humidity(pos)
	local base = climate_mod.settings.humidity
	local biome = minetest.get_humidity(pos)
	local random = climate_mod.state:get_int("humidity_random");
	return (base + biome)
end

return environment