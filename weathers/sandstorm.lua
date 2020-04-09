local name = weather_mod.modname .. ":sandstorm"

local weather = {
	priority = 50,
	damage = true,
	sound = "weather_wind"
}

weather.particles = {
	min_pos = {x=-9, y=-5, z=-9},
	max_pos = {x= 9, y= 5, z= 9},
	falling_speed=1,
	amount=40,
	exptime=0.8,
	size=15,
	texture="weather_sand.png"
}

weather.clouds = {
	density = 0.3,
	color = "#a4a0b685"
}

weather.conditions = {
	min_heat				= 50,
	max_humidity		= 25,
	min_windspeed		= 6
}

weather_mod.register_weather(name, weather)
