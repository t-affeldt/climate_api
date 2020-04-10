local name = weather_mod.modname .. ":pollen"

local config = {}

config.environment = {}

config.particles = {
	min_pos = {x=-12, y=-4, z=-12},
	max_pos = {x= 12, y= 1, z= 12},
	falling_speed=-0.1,
	amount=2,
	exptime=5,
	size=1,
	texture="weather_pollen.png"
}

config.conditions = {
	min_height = weather_mod.settings.min_height,
	max_height = weather_mod.settings.max_height,
	min_heat				= 40,
	min_humidity		= 30,
	max_humidity		= 40,
	max_windspeed		= 2
}

weather_mod.register_effect(name, config)
