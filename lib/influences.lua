climate_api.register_influence("heat", function(pos)
	return climate_api.environment.get_heat(pos)
end)

climate_api.register_influence("base_heat", function(pos)
	return minetest.get_heat(pos)
end)

climate_api.register_influence("humidity", function(pos)
	return climate_api.environment.get_humidity(pos)
end)

climate_api.register_influence("base_humidity", function(pos)
	return minetest.get_humidity(pos)
end)

climate_api.register_influence("biome", function(pos)
	local data = minetest.get_biome_data(pos)
	local biome = minetest.get_biome_name(data.biome)
	return biome
end)

climate_api.register_global_influence("windspeed", function()
	local wind = climate_api.environment.get_wind()
	return vector.length(wind)
end)

climate_api.register_global_influence("wind_yaw", function()
	local wind = climate_api.environment.get_wind()
	if vector.length(wind) == 0 then return 0 end
	return minetest.dir_to_yaw(wind)
end)

climate_api.register_influence("height", function(pos)
	return pos.y
end)

climate_api.register_influence("light", function(pos)
	pos = vector.add(pos, {x = 0, y = 1, z = 0})
	return minetest.env:get_node_light(pos)
end)

climate_api.register_influence("daylight", function(pos)
	pos = vector.add(pos, {x = 0, y = 1, z = 0})
	return minetest.env:get_node_light(pos, 0.5)
end)

climate_api.register_global_influence("time", function()
	return minetest.get_timeofday()
end)