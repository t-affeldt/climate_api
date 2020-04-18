return {
	sky_data = {
		base_color = nil,
		type = "regular",
		textures = nil,
		clouds = true,
		sky_color = {
			day_sky = "#8cbafa",
			day_horizon = "#9bc1f0",
			dawn_sky = "#b4bafa",
			dawn_horizon = "#bac1f0",
			night_sky = "#006aff",
			night_horizon = "#4090ff",
			indoors = "#646464",
			fog_tint_type = "default"
		}
	},
	cloud_data = {
		density = 0.4,
		color = "#fff0f0e5",
		ambient = "#000000",
		height = 120,
		thickness = 16,
		speed = {x=0, z=-2}
	},
	sun_data = {
		visible = true,
		texture = "sun.png",
		tonemap = "sun_tonemap.png",
		sunrise = "sunrisebg.png",
		sunrise_visible = true,
		scale = 1
	},
	moon_data = {
		visible = true,
		texture = "moon.png",
		tonemap = "moon_tonemap.png",
		scale = 1
	},
	star_data = {
		visible = true,
		count = 1000,
		star_color = "#ebebff69",
		scale = 1
	}
}