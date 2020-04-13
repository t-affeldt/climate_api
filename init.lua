assert(minetest.add_particlespawner, "[Climate API] This mod requires a more current version of Minetest")

climate_api = {}
climate_mod = {}

local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)

local function getBoolSetting(name, default)
	return minetest.is_yes(minetest.settings:get_bool("climate_api_" .. name) or default)
end

local function getNumericSetting(name, default)
	return tonumber(minetest.settings:get("climate_api_" .. name) or default)
end

-- load settings from config file
climate_mod.settings = {
	particles				= getBoolSetting("particles", true),
	skybox					= getBoolSetting("skybox", true),
	sound						= getBoolSetting("sound", true),
	wind						= getBoolSetting("wind", true),
	seasons					= getBoolSetting("seasons", true),
	heat						= getNumericSetting("heat_base", 0),
	humidity				= getNumericSetting("humidity_base", 0),
	time_spread			= getNumericSetting("time_spread", 1),
	particle_count	= getNumericSetting("particle_count", 1)
}

climate_mod.current_weather = {}
climate_mod.current_effects = {}

-- import core API
climate_mod.state = dofile(modpath .. "/lib/datastorage.lua")
climate_api = dofile(modpath .. "/lib/api.lua")
climate_api.utility = dofile(modpath .. "/lib/api_utility.lua")
climate_api.environment = dofile(modpath .. "/lib/environment.lua")
climate_mod.world = dofile(modpath .. "/lib/world.lua")
climate_mod.trigger = dofile(modpath .. "/lib/trigger.lua")
dofile(modpath.."/lib/main.lua")

-- import predefined environment effects
dofile(modpath .. "/ca_effects/particles.lua")
dofile(modpath .. "/ca_effects/skybox.lua")
