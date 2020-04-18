local environment = {}

local function get_heat_time()
	local time = minetest.get_timeofday()
	return climate_api.utility.normalized_cycle(time) * 0.6 + 0.7
end

local function get_heat_calendar()
	-- European heat center in August instead of June
	local day = minetest.get_day_count()
	local progression = ((day + 61) % 365) / 365
	return climate_api.utility.normalized_cycle(progression) * 0.6 + 0.7
end

local function get_heat_height(y)
	return climate_api.utility.rangelim((-y + 10) / 15, -10, 10)
end

function environment.get_heat(pos)
	local base = climate_mod.settings.heat
	local biome = minetest.get_heat(pos)
	local height = get_heat_height(pos.y)
	local time = get_heat_time()
	local date = get_heat_calendar()
	local random = climate_mod.state:get_float("heat_random");
	return (base + biome + height) * time * date * random
end

function environment.get_humidity(pos)
	local base = climate_mod.settings.humidity
	local biome = minetest.get_humidity(pos)
	local random = climate_mod.state:get_float("humidity_random");
	local random_base = climate_mod.state:get_float("humidity_base");
	return (base + biome * 0.7 + random_base * 0.3) * random
end

function environment.get_weather_presets(player)
	local pname = player:get_player_name()
	local weathers = climate_mod.current_weather[pname]
	if type(weathers) == "nil" then weathers = {} end
	return weathers
end

function environment.get_effects(player)
	local pname = player:get_player_name()
	local effects = {}
	for effect, players in pairs(climate_mod.current_effects) do
		if type(players[pname]) ~= "nil" then
			table.insert(effects, effect)
		end
	end
	return effects
end

return environment