if not climate_mod.settings.particles then return end

local EFFECT_NAME = "climate_api:particles"

local function get_particle_texture(particles)
	if type(particles.textures) == "nil" or next(particles.textures) == nil then
		return particles.texture
	end
	return particles.textures[math.random(#particles.textures)]
end

local function spawn_particles(player, particles)
	local ppos = player:getpos()
	local wind = climate_api.environment.get_wind()

	local amount = particles.amount * climate_mod.settings.particle_count
	local texture = get_particle_texture(particles)

	local vel = vector.new({
		x = wind.x,
		y = -particles.falling_speed,
		z = wind.z
	})

	if particles.acceleration == nil then
		particles.acceleration = vector.new({x=0, y=0, z=0})
	end

	local wind_pos = vector.multiply(
		vector.normalize(vel),
		-vector.length(wind)
	)
	wind_pos.y = 0
	local minp = vector.add(vector.add(ppos, particles.min_pos), wind_pos)
	local maxp = vector.add(vector.add(ppos, particles.max_pos), wind_pos)

	if particles.time == nil then
		particles.time = 0.5
	end

	if particles.vertical == nil then
		particles.vertical = math.abs(vector.normalize(vel).y) >= 0.6
	end

	if particles.size ~= nil then
		particles.min_size = particles.size
		particles.max_size = particles.size
	end

	minetest.add_particlespawner({
		amount = amount,
		time = particles.time,
		minpos = minp,
		maxpos = maxp,
		minvel = vel,
		maxvel = vel,
		minacc = particles.acceleration,
		maxacc = particles.acceleration,
		minexptime = particles.exptime,
		maxexptime = particles.exptime,
		minsize = particles.min_size,
		maxsize = particles.max_size,
		collisiondetection = true,
		collision_removal = true,
		vertical = particles.vertical,
		texture = texture,
		player = player:get_player_name()
	})
end

local function handle_effect(player_data)
	for playername, data in pairs(player_data) do
		local player = minetest.get_player_by_name(playername)
		for weather, value in pairs(data) do
			spawn_particles(player, value)
		end
	end
end

climate_api.register_effect(EFFECT_NAME, handle_effect, "tick")
climate_api.set_effect_cycle(EFFECT_NAME, climate_api.SHORT_CYCLE)