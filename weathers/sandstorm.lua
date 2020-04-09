local name = weather_mod.modname .. ":sandstorm"

local config = {}

config.environment = {
	damage = true
}

config.particles = {
	min_pos = {x=-9, y=-5, z=-9},
	max_pos = {x= 9, y= 5, z= 9},
	falling_speed=1,
	amount=40,
	exptime=0.8,
	size=15,
	texture="weather_sand.png"
}

config.conditions = {
	min_height = weather_mod.settings.min_height,
	max_height = weather_mod.settings.max_height,
	min_heat				= 50,
	max_humidity		= 25,
	min_windspeed		= 6
}

weather_mod.register_effect(name, config)
