local mod_player_monoids = minetest.get_modpath("player_monoids") ~= nil
local mod_playerphysics = minetest.get_modpath("playerphysics") ~= nil

function weather_mod.add_physics(player, effect, value)
	local id = weather_mod.modname .. ":" .. effect
	if mod_player_monoids then
		player_monoids[effect].add_change(player, value, id)
	elseif mod_playerphysics then
		playerphysics.add_physics_factor(player, effect, id, value)
	else
		local override = {}
		override[effect] = value
		player:set_physics_override(override)
	end
end

function weather_mod.remove_physics(player, effect)
	local id = weather_mod.modname .. ":" .. effect
	if mod_player_monoids then
		player_monoids[effect].del_change(player, id)
	elseif mod_playerphysics then
		playerphysics.remove_physics_factor(player, effect, id)
	else
		local override = {}
		override[effect] = 1
		player:set_physics_override(override)
	end
end

function weather_mod.is_outdoors(player)
	return minetest.get_node_light(player:getpos(), 0.5) == 15
end

function weather_mod.set_clouds(player)
	if not weather_mod.settings.skybox then
		return
	end
	local ppos = player:get_pos()
	local humidity = weather_mod.get_humidity(ppos) / 100
	local clouds = {}
	clouds.speed = vector.multiply(weather_mod.state.wind, 2)
	clouds.color = "#fff0f0c5"
	clouds.density = math.max(math.min(humidity, 0.8), 0.1)
	player:set_clouds(clouds)
end

function weather_mod.play_sound(player, effect)
	local playername = player:get_player_name()
	if not effect.sound_handles[playername] then
		local handle = minetest.sound_play(effect.config.sound, {
			to_player = playername,
			loop = true
		})
		if handle then
			effect.sound_handles[playername] = handle
			effect.sound_volumes[playername] = effect.config.sound.gain or 1
		end
	end
end

function weather_mod.stop_sound(player, effect)
	local playername = player:get_player_name()
	if effect.sound_handles[playername] then
		minetest.sound_stop(effect.sound_handles[playername])
		effect.sound_handles[playername] = nil
		effect.sound_volumes[playername] = nil
	end
end

function weather_mod.handle_sounds(player, sounds)
	local playername = player:get_player_name()
	for name, effect in pairs(weather_mod.weathers) do
		if type(effect.sound_handles[playername]) == "nil" and type(sounds[name]) ~= "nil" then
			weather_mod.play_sound(player, effect)
		elseif type(effect.sound_handles[playername]) ~= "nil" and type(sounds[name]) == "nil" then
			weather_mod.stop_sound(player, effect)
		elseif type(effect.sound_handles[playername]) ~= "nil" and type(sounds[name]) ~= "nil" then
			local volume = sounds[name].gain or 1
			if effect.sound_volumes[playername] ~= volume then
				minetest.sound_fade(effect.sound_handles[playername], 1, volume)
			end
		end
	end
end

function weather_mod.damage_player(player, amount, reason)
	if not weather_mod.settings.damage then
		return
	end
	local hp = player:get_hp()
	player:set_hp(current_hp - amount, reason)
end