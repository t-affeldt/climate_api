if not climate_mod.settings.particles then return end

local function get_particle_texture(particles)
	if type(particles.textures) == "nil" or next(particles.textures) == nil then
		return particles.texture
	end
	return particles.textures[math.random(#particles.textures)]
end

local function spawn_particles(player, particles)
	local ppos = player:getpos()
	local wind_x = climate_mod.state:get_int("wind_x")
	local wind_z = climate_mod.state:get_int("wind_z")
	local wind = vector.new(wind_x, 0, wind_z)
	local wind_pos = vector.multiply(wind, -1)
	local wind_speed = vector.length(wind)

	local texture = get_particle_texture(particles)

	local minp = vector.add(vector.add(ppos, particles.min_pos), wind_pos)
	local maxp = vector.add(vector.add(ppos, particles.max_pos), wind_pos)

	local vel = vector.new({
		x = wind.x,
		y = -particles.falling_speed,
		z = wind.z
	})
	local acc = vector.new({x=0, y=0, z=0})

	local exp = particles.exptime
	local vertical = math.abs(vector.normalize(vel).y) >= 0.6

	minetest.add_particlespawner({
		amount = particles.amount,
		time = 0.5,
		minpos = minp,
		maxpos = maxp,
		minvel = vel,
		maxvel = vel,
		minacc = acc,
		maxacc = acc,
		minexptime = exp,
		maxexptime = exp,
		minsize = particles.size,
		maxsize = particles.size,
		collisiondetection = true,
		collision_removal = true,
		vertical = vertical,
		texture = texture,
		player = player:get_player_name()
	})
end

local function handle_effect(player_data)
	for playername, data in pairs(player_data) do
		minetest.chat_send_player(playername, "spam")
		local player = minetest.get_player_by_name(playername)
		for weather, value in pairs(data) do
			spawn_particles(player, value)
		end
	end
end

climate_api.register_effect("climate_api:particles", handle_effect, "tick")
climate_api.set_effect_cycle("climate_api:particles", climate_api.SHORT_CYCLE)