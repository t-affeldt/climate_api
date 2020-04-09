local name = weather_mod.modname .. ":storm"

local config = {}

config.sound = {
	name = "weather_wind",
	gain = 1
}

config.conditions = {
	min_height = weather_mod.settings.min_height,
	max_height = weather_mod.settings.max_height,
	min_windspeed = 5
}

local function override(params)
	local avg_windspeed = 6
	local intensity = params.windspeed / avg_windspeed
	local dynamic_config = {
		sound = {
			gain = math.min(intensity, 1.2)
		}
	}
	return dynamic_config
end

weather_mod.register_effect(name, config, override)
