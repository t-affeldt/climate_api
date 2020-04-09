local name = weather_mod.modname .. ":clear"

local weather = {
	priority = 0
}

weather.clouds = {
	density = 0.3,
	color = "#fff0f0c5"
}

weather_mod.register_weather(name, weather)
