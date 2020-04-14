assert(minetest.add_particlespawner, "[Climate API] This mod requires a more current version of Minetest")

climate_api = {}
climate_mod = {}

local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)

local function getBoolSetting(name, default)
	local value = minetest.settings:get_bool("climate_api_" .. name)
	if type(value) == "nil" then value = default end
	return minetest.is_yes(value)
end

local function getNumericSetting(name, default)
	local value = minetest.settings:get("climate_api_" .. name)
	if type(value) == "nil" then value = default end
	return tonumber(value)
end

-- load settings from config file
climate_mod.settings = {
	particles				= getBoolSetting("particles", true),
	skybox					= getBoolSetting("skybox", true),
	sound						= getBoolSetting("sound", true),
	wind						= getBoolSetting("wind", true),
	seasons					= getBoolSetting("seasons", true),
	fahrenheit			= getBoolSetting("fahrenheit", false),
	heat						= getNumericSetting("heat_base", 0),
	humidity				= getNumericSetting("humidity_base", 0),
	time_spread			= getNumericSetting("time_spread", 1),
	particle_count	= getNumericSetting("particle_count", 1)
}

-- initiate empty registers
climate_mod.current_weather = {}
climate_mod.current_effects = {}
climate_mod.weathers = {}
climate_mod.effects = {}
climate_mod.cycles = {}
climate_mod.influences = {}

-- import core API
climate_mod.state = dofile(modpath .. "/lib/datastorage.lua")
climate_api = dofile(modpath .. "/lib/api.lua")
climate_api.utility = dofile(modpath .. "/lib/api_utility.lua")
climate_api.environment = dofile(modpath .. "/lib/environment.lua")
--climate_api = dofile(modpath .. "/lib/influences.lua")
climate_mod.world = dofile(modpath .. "/lib/world.lua")
climate_mod.trigger = dofile(modpath .. "/lib/trigger.lua")
dofile(modpath.."/lib/main.lua")
dofile(modpath.."/lib/commands.lua")

-- import predefined environment effects
dofile(modpath .. "/ca_effects/clouds.lua")
dofile(modpath .. "/ca_effects/particles.lua")
dofile(modpath .. "/ca_effects/skybox.lua")
dofile(modpath .. "/ca_effects/sound.lua")
