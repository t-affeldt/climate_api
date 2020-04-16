if not climate_mod.settings.sound then return end

local EFFECT_NAME = "climate_api:hud_overlay"

local handles = {}
local function apply_hud(pname, weather, hud)
	if handles[pname] == nil then handles[pname] = {} end
	if handles[pname][weather] ~= nil then return end
	local player = minetest.get_player_by_name(pname)
	local handle = player:hud_add({
		name = weather,
		hud_elem_type = "image",
		position = {x = 0, y = 0},
		alignment = {x = 1, y = 1},
		scale = { x = -100, y = -100},
		z_index = hud.z_index,
		text = hud.file,
		offset = {x = 0, y = 0}
	})
	handles[pname][weather] = handle
end

local function remove_hud(pname, weather, hud)
	if handles[pname] == nil or handles[pname][weather] == nil then return end
	local handle = handles[pname][weather]
	local player = minetest.get_player_by_name(pname)
	player:hud_remove(handle)
	handles[pname][weather] = nil
end

local function start_effect(player_data)
	for playername, data in pairs(player_data) do
		for weather, value in pairs(data) do
			apply_hud(playername, weather, value)
		end
	end
end

local function handle_effect(player_data, prev_data)
	for playername, data in pairs(player_data) do
		for weather, value in pairs(data) do
			if prev_data[playername][weather] == nil then
				apply_hud(playername, weather, value)
			end
		end
	end

	for playername, data in pairs(prev_data) do
		for weather, value in pairs(data) do
			if player_data[playername][weather] == nil then
				remove_hud(playername, weather, value)
			end
		end
	end
end

local function stop_effect(prev_data)
	for playername, data in pairs(prev_data) do
		for weather, value in pairs(data) do
			remove_hud(playername, weather, value)
		end
	end
end

climate_api.register_effect(EFFECT_NAME, start_effect, "start")
climate_api.register_effect(EFFECT_NAME, handle_effect, "tick")
climate_api.register_effect(EFFECT_NAME, stop_effect, "stop")
climate_api.set_effect_cycle(EFFECT_NAME, climate_api.MEDIUM_CYCLE)