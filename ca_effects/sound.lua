if not climate_mod.settings.sound then return end

return

local function update_effect(player_data)
	for playername, data in pairs(player_data) do
		for weather, value in pairs(data) do
			climate_mod.effects.play_sound(player, value)
		end
	end
end

climate_api.register_effect("climate_api:sound", update_effect, "change")
climate_api.set_effect_cycle("climate_api:skybox", climate_api.MEDIUM_CYCLE)