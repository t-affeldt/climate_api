local name = weather_mod.modname .. ":rainstorm"

local weather = {
	priority = 30,
	damage = true,
	spawn_puddles = true,
	wetten_farmland = true,
	lightning = true,
	sound = "weather_rain2"
}

weather.particles = {
	min_pos = {x=-9, y=7, z=-9},
	max_pos = {x= 9, y=7, z= 9},
	falling_speed=10,
	amount=25,
	exptime=0.8,
	size=25,
	texture="weather_rain.png"
}

weather.clouds = {
	density = 0.7,
	color = "#a4a0b6f5"
}

weather.conditions = {
	min_heat				= 30,
	min_humidity		= 60,
	min_windspeed		= 5
}

weather_mod.register_weather(name, weather)
