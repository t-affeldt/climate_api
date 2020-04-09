local name = weather_mod.modname .. ":rain"

local weather = {
	priority = 10,
	spawn_puddles = true,
	wetten_farmland = true,
	sound = "weather_rain1"
}

weather.particles = {
	min_pos = {x=-9, y=7, z=-9},
	max_pos = {x= 9, y=7, z= 9},
	falling_speed=10,
	amount=20,
	exptime=0.8,
	size=25,
	texture="weather_rain.png"
}

weather.clouds = {
	density = 0.5,
	color = "#a4a0b6e5"
}

weather.conditions = {
	min_heat			= 30,
	min_humidity	= 40
}

weather_mod.register_weather(name, weather)
