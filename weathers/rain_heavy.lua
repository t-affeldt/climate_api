local name = weather_mod.modname .. ":rain_heavy"

local config = {}

config.environment = {
	spawn_puddles = true,
	wetten_farmland = true,
	lightning = true
}

config.sound = {
	name = "weather_rain",
	gain = 1
}

config.particles = {
	min_pos = {x=-9, y=7, z=-9},
	max_pos = {x= 9, y=7, z= 9},
	falling_speed=10,
	amount=20,
	exptime=0.8,
	size=25,
	texture="weather_rain.png"
}

config.conditions = {
	min_height = weather_mod.settings.min_height,
	max_height = weather_mod.settings.max_height,
	min_heat			= 30,
	min_humidity	= 60
}

weather_mod.register_effect(name, config)
