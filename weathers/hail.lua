local name = weather_mod.modname .. ":hail"

local config = {}

config.environment = {
	spawn_puddles = true,
	lightning = true,
	damage = true
}

config.sound = {
	name = "weather_hail",
	gain = 1
}

config.particles = {
	min_pos = {x=-9, y=7, z=-9},
	max_pos = {x= 9, y=7, z= 9},
	falling_speed=15,
	amount=5,
	exptime=0.8,
	size=1,
	textures = {}
}

for i = 1,5,1 do
	config.particles.textures[i] = "weather_hail" .. i .. ".png"
end

config.conditions = {
	min_height = weather_mod.settings.min_height,
	max_height = weather_mod.settings.max_height,
	max_heat				= 45,
	min_humidity		= 65,
	min_windspeed		= 2.5
}

weather_mod.register_effect(name, config)
