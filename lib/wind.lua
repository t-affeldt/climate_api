function weather_mod.set_headwind(player)
	local movement = vector.normalize(player:get_player_velocity())
	local product = vector.dot(movement, weather_mod.state.wind)
	-- logistic function, scales between 0 and 2
	-- see https://en.wikipedia.org/wiki/Logistic_function
	local L = 1.6 -- maximum value
	local k = 0.15 -- growth rate
	local z = 0.8 -- midpoint
	local o = 0.1 -- y offset
	local factor = L / (1 + math.exp(-k * (product - z))) + o
	weather_mod.add_physics(player, "speed", factor)
end