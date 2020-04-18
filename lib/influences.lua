climate_api.register_influence("heat", function(pos)
	return climate_api.environment.get_heat(pos)
end)

climate_api.register_influence("humidity", function(pos)
	return climate_api.environment.get_humidity(pos)
end)

climate_api.register_influence("biome", function(pos)
	local data = minetest.get_biome_data(pos)
	local biome = minetest.get_biome_name(data.biome)
	return biome
end)

climate_api.register_influence("windspeed", function(_)
	local wind_x = climate_mod.state:get_float("wind_x")
	local wind_z = climate_mod.state:get_float("wind_z")
	return vector.length({x = wind_x, y = 0, z = wind_z})
end)

climate_api.register_influence("wind_x", function(_)
	return climate_mod.state:get_float("wind_x")
end)

climate_api.register_influence("wind_z", function(_)
	return climate_mod.state:get_float("wind_z")
end)

climate_api.register_influence("height", function(pos)
	return pos.y
end)

climate_api.register_influence("light", function(pos)
	return minetest.env:get_node_light(pos)
end)

climate_api.register_influence("daylight", function(pos)
	return minetest.env:get_node_light(pos, 0.5)
end)

climate_api.register_influence("time", function(_)
	return minetest.get_timeofday()
end)