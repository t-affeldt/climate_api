local world = {}

local WIND_SPREAD = 600
local WIND_SCALE = 3
local HEAT_SPREAD = 2400
local HEAT_SCALE = 0.2
local HUMIDITY_SPREAD = 1200
local HUMIDITY_SCALE = 0.18

local nobj_wind_x
local nobj_wind_z
local nobj_heat
local nobj_humidity

local pn_wind_speed_x = {
	offset = 0,
	scale = WIND_SCALE,
	spread = {x = WIND_SPREAD, y = WIND_SPREAD, z = WIND_SPREAD},
	seed = 31441,
	octaves = 2,
	persist = 0.5,
	lacunarity = 2
}

local pn_wind_speed_z = {
	offset = 0,
	scale = WIND_SCALE,
	spread = {x = WIND_SPREAD, y = WIND_SPREAD, z = WIND_SPREAD},
	seed = 938402,
	octaves = 2,
	persist = 0.5,
	lacunarity = 2
}

local pn_heat = {
	offset = 0,
	scale = HEAT_SCALE,
	spread = {x = HEAT_SPREAD, y = HEAT_SPREAD, z = HEAT_SPREAD},
	seed = 24,
	octaves = 2,
	persist = 0.5,
	lacunarity = 2
}

local pn_humidity = {
	offset = 0,
	scale = HUMIDITY_SCALE,
	spread = {x = HUMIDITY_SPREAD, y = HUMIDITY_SPREAD, z = HUMIDITY_SPREAD},
	seed = 8374061,
	octaves = 3,
	persist = 0.5,
	lacunarity = 2
}

local function update_wind(timer)
	nobj_wind_x = nobj_wind_x or minetest.get_perlin(pn_wind_speed_x)
	nobj_wind_z = nobj_wind_z or minetest.get_perlin(pn_wind_speed_z)
	local n_wind_x = nobj_wind_x:get_2d({x = timer, y = 0})
	local n_wind_z = nobj_wind_z:get_2d({x = timer, y = 0})
	climate_mod.state:set_int("wind_x", n_wind_x)
	climate_mod.state:set_int("wind_z", n_wind_z)
end

local function update_heat(timer)
	nobj_heat = nobj_heat or minetest.get_perlin(pn_heat)
	local n_heat = nobj_heat:get_2d({x = timer, y = 0})
	climate_mod.state:set_int("heat_random", n_heat)
end

local function update_humidity(timer)
	nobj_humidity = nobj_humidity or minetest.get_perlin(pn_humidity)
	local n_humidity = nobj_humidity:get_2d({x = timer, y = 0})
	climate_mod.state:set_int("humidity_random", n_humidity)
end

local function update_date()
	local time = minetest.get_timeofday()
	if time < climate_mod.state:get_int("time_last_check") then
		local day = climate_mod.state:get_int("time_current_day")
		climate_mod.state:set_int("time_current_day ", day + 1)
	end
	climate_mod.state:set_int("time_last_check", time)
end

function world.update_status(timer)
	update_date()
	update_wind(timer)
	update_heat(timer)
	update_humidity(timer)
end

return world