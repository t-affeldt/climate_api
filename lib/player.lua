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

-- function taken from weather mod
-- see https://github.com/theFox6/minetest_mod_weather/blob/master/weather/api.lua#L110
local function raycast(player, origin)
	local hitpos = vector.add(player:get_pos(),vector.new(0,1,0))
	local ray = minetest.raycast(origin,hitpos)
	local o = ray:next()
	if not o then return false end
	if o.type~="object" then return false end -- hit node or something
	if not o.ref:is_player() then return false end -- hit different object
	if o.ref:get_player_name() ~= player:get_player_name() then
		return false --hit other player
	end
	o = ray:next()
	if o then
		minetest.log("warning","[ultimate_weather] raycast hit more after hitting the player\n"..
			dump2(o,"o"))
	end
	return true
end

local function check_light(player)
	return minetest.get_node_light(player:getpos(), 0.5) == 15
end

function weather_mod.is_outdoors(player, origin)
	if weather_mod.settings.raycasting then
		return raycast(player, origin)
	else
		return check_light(player)
	end
end

function weather_mod.set_headwind(player, wind)
	local movement = vector.normalize(player:get_player_velocity())
	local product = vector.dot(movement, wind)
	-- logistic function, scales between 0 and 2
	-- see https://en.wikipedia.org/wiki/Logistic_function
	local L = 2 -- maximum value
	local k = 0.1 -- growth rate
	local z = 1 -- midpoint
	local factor = L / (1 + math.exp(-k * (product - z)))
	weather_mod.add_physics(player, "speed", factor)
end