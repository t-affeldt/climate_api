local name = weather_mod.modname .. ":snow_heavy"

local config = {}

config.environment = {
	spawn_snow = true
}

config.particles = {
	min_pos = {x=-12, y= 5, z=-12},
	max_pos = {x= 12, y=9, z= 12},
	falling_speed=1,
	amount=1,
	exptime=8,
	size=12,
	texture="weather_snow.png"
}

config.conditions = {
	min_height = weather_mod.settings.min_height,
	max_height = weather_mod.settings.max_height,
	max_heat				= 40,
	min_humidity		= 55
}

local function override(params)
	local avg_humidity = 55
	local intensity = params.humidity / avg_humidity
	local dynamic_config = {
		sound = {
			gain = math.min(intensity, 1.2)
		},
		particles = {
			amount = 50 * math.min(intensity, 1.5),
			falling_speed = 1 / math.min(intensity, 1.3)
		}
	}
	return dynamic_config
end

weather_mod.register_effect(name, config, override)
