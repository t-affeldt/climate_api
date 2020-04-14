if not climate_mod.settings.skybox then return end
if not minetest.get_modpath("skylayer") then return end

local SKYBOX_NAME = "climate_api:skybox"

local function set_skybox(player, sky)
	sky.name = SKYBOX_NAME
	skylayer.add_layer(player:get_player_name(), sky)
end

local function remove_skybox(player)
	skylayer.remove_layer(player:get_player_name(), SKYBOX_NAME)
end

local function handle_effect(player_data)
	for playername, data in pairs(player_data) do
		local player = minetest.get_player_by_name(playername)
		local sky = {}
		for weather, value in pairs(data) do
			climate_api.utility.merge_tables(sky, value)
		end
		set_skybox(player, sky)
	end
end

local function remove_effect(player_data)
	for playername, data in ipairs(player_data) do
		local player = minetest.get_player_by_name(playername)
		remove_skybox(player)
	end
end

climate_api.register_effect("climate_api:skybox", handle_effect, "tick")
climate_api.register_effect("climate_api:skybox", remove_effect, "stop")
climate_api.set_effect_cycle("climate_api:skybox", climate_api.LONG_CYCLE)