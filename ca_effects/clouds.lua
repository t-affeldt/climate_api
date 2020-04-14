if not climate_mod.settings.skybox then return end
if not minetest.get_modpath("skylayer") then return end

local SKYBOX_NAME = "climate_api:clouds"

local function set_clouds(player, clouds)
	sky = { name = SKYBOX_NAME, cloud_data = clouds }
	skylayer.add_layer(player:get_player_name(), sky)
end

local function remove_cloud_layer(player)
	skylayer.remove_layer(player:get_player_name(), SKYBOX_NAME)
end

local function accumulate(current, incoming, fn)
	if type(incoming) ~= "nil" and type(current) == "nil" then
		return incoming
	elseif type(incoming) ~= "nil" then
		return fn(current, incoming)
	end
	return current
end

local function handle_effect(player_data)
	for playername, data in pairs(player_data) do
		local player = minetest.get_player_by_name(playername)
		local clouds = {}
		for weather, value in pairs(data) do
			clouds.size = accumulate(clouds.size, data.size, function(a, b) return a * b end)
			clouds.speed = accumulate(clouds.speed, data.speed, vector.multiply)
			if type(data.color) ~= "nil" then
				clouds.color = data.color
			end
		end
		set_clouds(player, clouds)
	end
end

local function remove_effect(player_data)
	for playername, data in ipairs(player_data) do
		local player = minetest.get_player_by_name(playername)
		remove_cloud_layer(player)
	end
end

climate_api.register_effect("climate_api:clouds", handle_effect, "tick")
climate_api.register_effect("climate_api:clouds", remove_effect, "end")
climate_api.set_effect_cycle("climate_api:clouds", climate_api.LONG_CYCLE)