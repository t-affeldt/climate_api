assert(minetest.add_particlespawner, "Ultimate Weather requires a more current version of Minetest")
weather_mod = {}

weather_mod.modname = "ultimate_weather"
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
	weather			= getBoolSetting("weather", true),
	leaves			= getBoolSetting("leaves", true),
	snow				= getBoolSetting("snow_layers", true),
	puddles			= getBoolSetting("puddles", true),
	skybox			= getBoolSetting("skybox", true),
	raycasting	= getBoolSetting("raycasting", true),
	wind				= getBoolSetting("wind", true),
	flowers			= getBoolSetting("flowers", true),
	fruit				= getBoolSetting("fruit", true),
	soil				= getBoolSetting("soil", true),
	seasons			= getBoolSetting("seasons", true),
	heat				= getNumericSetting("heat", 0),
	humidity		= getNumericSetting("humidity", 0),
	max_height	= getNumericSetting("max_height", 120),
	min_height	= getNumericSetting("min_height", -50)
}

weather_mod.state = {
	current_weather = weather_mod.modname .. ":snowstorm",
	heat = 1,
	humidity = 1
}

-- import core API
dofile(weather_mod.modpath.."/lib/player.lua")
dofile(weather_mod.modpath.."/lib/environment.lua")
dofile(weather_mod.modpath.."/lib/lightning.lua")
dofile(weather_mod.modpath.."/lib/main.lua")

-- import individual weather types
dofile(weather_mod.modpath.."/weathers/clear.lua")
dofile(weather_mod.modpath.."/weathers/rain.lua")
dofile(weather_mod.modpath.."/weathers/rainstorm.lua")
dofile(weather_mod.modpath.."/weathers/snow.lua")
dofile(weather_mod.modpath.."/weathers/snowstorm.lua")
dofile(weather_mod.modpath.."/weathers/sandstorm.lua")
