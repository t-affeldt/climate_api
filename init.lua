assert(minetest.add_particlespawner, "Believable Weather requires a more current version of Minetest")
weather_mod = {}

weather_mod.modname = "believable_weather"
weather_mod.modpath = minetest.get_modpath(weather_mod.modname)

local function getBoolSetting(name, default)
	return minetest.is_yes(minetest.settings:get_bool(weather_mod.modname .. "_" .. name) or default)
end

local function getNumericSetting(name, default)
	return tonumber(minetest.settings:get(weather_mod.modname .. "_" .. name) or default)
end

-- load settings from config file
weather_mod.settings = {
	damage			= getBoolSetting("damage", true),
	particles		= getBoolSetting("particles", true),
	leaves			= getBoolSetting("leaves", true),
	snow				= getBoolSetting("snow_layers", true),
	puddles			= getBoolSetting("puddles", true),
	skybox			= getBoolSetting("skybox", true),
	raycasting	= getBoolSetting("raycasting", true),
	wind				= getBoolSetting("wind", true),
	wind_slow		= getBoolSetting("wind_slow", true),
	flowers			= getBoolSetting("flowers", true),
	fruit				= getBoolSetting("fruit", true),
	soil				= getBoolSetting("soil", true),
	seasons			= getBoolSetting("seasons", true),
	heat				= getNumericSetting("base_heat", 0),
	humidity		= getNumericSetting("base_humidity", 0),
	max_height	= getNumericSetting("max_height", 120),
	min_height	= getNumericSetting("min_height", -50)
}

dofile(weather_mod.modpath.."/lib/datastorage.lua")
weather_mod.state = weather_mod.get_storage()

-- import core API
dofile(weather_mod.modpath.."/lib/player.lua")
dofile(weather_mod.modpath.."/lib/environment.lua")
dofile(weather_mod.modpath.."/lib/wind.lua")
dofile(weather_mod.modpath.."/lib/calendar_dictionary.lua")
dofile(weather_mod.modpath.."/lib/calendar.lua")
dofile(weather_mod.modpath.."/lib/main.lua")
dofile(weather_mod.modpath.."/lib/commands.lua")

-- import individual weather types
dofile(weather_mod.modpath.."/weathers/rain.lua")
dofile(weather_mod.modpath.."/weathers/rain_heavy.lua")
dofile(weather_mod.modpath.."/weathers/snow.lua")
dofile(weather_mod.modpath.."/weathers/snow_heavy.lua")
dofile(weather_mod.modpath.."/weathers/storm.lua")
dofile(weather_mod.modpath.."/weathers/sandstorm.lua")
