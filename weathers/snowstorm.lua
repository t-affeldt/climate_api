local name = weather_mod.modname .. ":snowstorm"

local weather = {
	priority = 40,
	damage = true,
	lightning = true,
	spawn_snow = true,
	sound = "weather_wind"
}

weather.particles = {
	min_pos = {x=-9, y=-5, z=-9},
	max_pos = {x= 9, y= 5, z= 9},
	falling_speed=1.5,
	amount=70,
	exptime=6,
	size=1,
	textures = {}
}

for i = 1,12,1 do
	weather.particles.textures[i] = "weather_snowflake" .. i .. ".png"
end

weather.clouds = {
	density = 0.7,
	color = "#a4a0b6f5"
}

weather.conditions = {
	max_heat				= 30,
	min_humidity		= 60,
	min_windspeed   = 5
}

weather_mod.register_weather(name, weather)
