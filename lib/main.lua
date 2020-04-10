local GSCYCLE = 0.05
local RECALCCYCLE = 0

weather_mod.weathers = {}
function weather_mod.register_effect(name, config, override)
	-- TODO: check and sanitize
	weather_mod.weathers[name] = {
		config = config,
		override = override,
		sound_handles = {},
		sound_volumes = {}
	}
end

-- from https://stackoverflow.com/a/29133654
local function merge(a, b)
	if type(a) == 'table' and type(b) == 'table' then
		for k,v in pairs(b) do if type(v)=='table' and type(a[k] or false)=='table' then merge(a[k],v) else a[k]=v end end
	end
	return a
end

local function build_effect_config(weather, climate)
	local config = weather.config
	local override = weather.override
	if type(override) == "nil" then
		return config
	end
	local dynamic_config = override(climate)
	return merge(config, dynamic_config)
end

local function get_texture(particles)
	if type(particles.textures) == "nil" or next(particles.textures) == nil then
		return particles.texture
	end
	return particles.textures[math.random(#particles.textures)]
end

local function spawn_particles(player, particles, wind)
	local ppos = player:getpos()
	local wind_pos = vector.multiply(weather_mod.state.wind,-1)
	local wind_speed = vector.length(weather_mod.state.wind)

	local texture = get_texture(particles)

	local minp = vector.add(vector.add(ppos, particles.min_pos),wind_pos)
	local maxp = vector.add(vector.add(ppos, particles.max_pos),wind_pos)

	local vel = vector.new({
		x=weather_mod.state.wind.x,
		y=-particles.falling_speed,
		z=weather_mod.state.wind.z
	})
	local acc = vector.new({x=0, y=0, z=0})

	local exp = particles.exptime
	local vertical = math.abs(vector.normalize(vel).y) >= 0.6

	minetest.add_particlespawner({
		amount=particles.amount,
		time=0.5,
		minpos=minp,
		maxpos=maxp,
		minvel=vel,
		maxvel=vel,
		minacc=acc,
		maxacc=acc,
		minexptime=exp,
		maxexptime=exp,
		minsize=particles.size,
		maxsize=particles.size,
		collisiondetection=true,
		collision_removal=true,
		vertical=vertical,
		texture=texture,
		player=player:get_player_name()
	})
end

local function handle_weather_effects(player)
	local ppos = player:getpos()
	local climate = weather_mod.get_climate(ppos)
	local active_effects = weather_mod.get_effects(climate)
	local environment_flags = {}
	local sounds = {}

	for _, effect in ipairs(active_effects) do
		local weather = weather_mod.weathers[effect]
		local config = build_effect_config(weather, climate)

		local outdoors = weather_mod.is_outdoors(player)
		if type(config.particles) ~= "nil" and outdoors then
			spawn_particles(player, config.particles, weather_mod.state.wind)
		end
		if type(config.sound) ~= "nil" and outdoors then
			sounds[effect] = config.sound
		end
		if type(config.environment) ~= "nil" and outdoors then
			for flag, value in pairs(config.environment) do
				if value ~= false then
					environment_flags[flag] = value
				end
			end
		end
	end
	weather_mod.handle_sounds(player, sounds)
	weather_mod.handle_events(player, environment_flags)
end

local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer < GSCYCLE then return end
	for _, player in ipairs(minetest.get_connected_players()) do
		handle_weather_effects(player)
		if timer >= RECALCCYCLE then
			weather_mod.set_clouds(player)
			weather_mod.set_headwind(player)
		end
	end
	timer = 0
end)