if not climate_mod.settings.skybox then return end

local EFFECT_NAME = "climate_api:skybox"

local function handle_effect(player_data, prev_data)
	for playername, data in pairs(prev_data) do
		for weather, _ in pairs(data) do
			if player_data[playername] == nil or player_data[playername][weather] == nil then
				climate_api.skybox.remove_layer(playername, weather)
			end
		end
	end
	for playername, data in pairs(player_data) do
		for weather, value in pairs(data) do
			climate_api.skybox.add_layer(playername, weather, value)
		end
		climate_api.skybox.update_skybox(playername)
	end
end

local function remove_effect(player_data)
	for playername, data in pairs(player_data) do
		for weather, _ in pairs(data) do
			climate_api.skybox.remove_layer(playername, weather)
		end
	end
end

climate_api.register_effect(EFFECT_NAME, handle_effect, "tick")
climate_api.register_effect(EFFECT_NAME, remove_effect, "stop")
climate_api.set_effect_cycle("climate_api:skybox", climate_api.MEDIUM_CYCLE)