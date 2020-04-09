function weather_mod.set_headwind(player, wind)
	local movement = vector.normalize(player:get_player_velocity())
	local product = vector.dot(movement, wind)
	-- logistic function, scales between 0.5 and 1.5
	-- see https://en.wikipedia.org/wiki/Logistic_function
	local factor = 1 / (1 + math.exp(-0.1 * (product - 0.5))) + 0.5
	weather_mod.add_physics(player, "speed", factor)
end