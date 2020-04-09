local name = weather_mod.modname .. ":rain"

local config = {}

config.environment = {
	spawn_puddles = true,
	wetten_farmland = true
}

config.sound = {
	name = "weather_rain",
	gain = 1
}

config.particles = {
	min_pos = {x=-9, y=7, z=-9},
	max_pos = {x= 9, y=7, z= 9},
	falling_speed=10,
	amount=40,
	exptime=0.8,
	size=1,
	texture = "weather_raindrop.png"
}

config.conditions = {
	min_height = weather_mod.settings.min_height,
	max_height = weather_mod.settings.max_height,
	min_heat			= 30,
	min_humidity	= 40,
	max_humidity	= 60
}

local function override(params)
	local avg_humidity = 40
	local intensity = params.humidity / avg_humidity
	local dynamic_config = {
		sound = {
			gain = math.min(intensity, 1.2)
		},
		particles = {
			amount = 20 * math.min(intensity, 1.5),
			falling_speed = 10 / math.min(intensity, 1.3)
		}
	}
	return dynamic_config
end

weather_mod.register_effect(name, config, override)
