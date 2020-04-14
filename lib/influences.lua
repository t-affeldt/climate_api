climate_api.register_influence("heat", function(player)
	return climate_mod.get_heat(player:get_pos())
end)

climate_api.register_influence("humidity", function(player)
	return climate_mod.get_humidity(player:get_pos())
end)

climate_api.register_influence("windspeed", function(player)
	local wind_x = climate_mod.state:get_float("wind_x")
	local wind_z = climate_mod.state:get_float("wind_z")
	return vector.length({x = wind_x, y = 0, z = wind_z})
end)

climate_api.register_influence("wind_x", function(player)
	return climate_mod.state:get_float("wind_x")
end)

climate_api.register_influence("wind_z", function(player)
	return climate_mod.state:get_float("wind_z")
end)

climate_api.register_influence("height", function(player)
	local ppos = player:get_pos()
	return ppos.y
end)

climate_api.register_influence("light", function(player)
	return minetest.env:get_node_light(player:get_pos(), 0.5)
end)