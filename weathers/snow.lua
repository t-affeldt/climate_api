local name = weather_mod.modname .. ":snow"

local weather = {
	priority = 20,
	spawn_snow = true
}

weather.particles = {
	min_pos = {x=-20, y= 3, z=-20},
	max_pos = {x= 20, y=12, z= 20},
	falling_speed=1,
	amount=50,
	exptime=15,
	size=1,
	textures = {}
}

for i = 1,12,1 do
	weather.particles.textures[i] = "weather_snowflake" .. i .. ".png"
end

weather.clouds = {
	density = 0.5,
	color = "#a4a0b6e5"
}

weather.conditions = {
	max_heat				= 30,
	min_humidity		= 40
}

weather_mod.register_weather(name, weather)
