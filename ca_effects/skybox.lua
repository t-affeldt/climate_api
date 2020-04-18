if not climate_mod.settings.skybox then return end

local EFFECT_NAME = "climate_api:skybox"

local function set_skybox(player, sky)
	if not player.get_stars then return end
	if sky.sky_data ~= nil then
		player:set_sky(sky.sky_data)
	end
	if sky.cloud_data ~= nil then
		player:set_clouds(sky.cloud_data)
	end
	if sky.moon_data ~= nil then
		player:set_moon(sky.moon_data)
	end
	if sky.sun_data ~= nil then
		player:set_sun(sky.sun_data)
	end
	if sky.stars_data ~= nil then
		player:set_sun(sky.stars_data)
	end
end

local function remove_skybox(player)
	if not player.get_stars then return end
	player:set_sky({ type = "regular", clouds = true})
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
	for playername, data in pairs(player_data) do
		local player = minetest.get_player_by_name(playername)
		remove_skybox(player)
	end
end

climate_api.register_effect(EFFECT_NAME, handle_effect, "tick")
climate_api.register_effect(EFFECT_NAME, remove_effect, "stop")
--climate_api.set_effect_cycle("climate_api:skybox", climate_api.LONG_CYCLE)