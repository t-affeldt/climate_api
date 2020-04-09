local GSCYCLE = 0
local temperature = 10
local humidity = 100
local wind = vector.new(10, 0, -0.25)

weather_mod.weathers = {}
function weather_mod.register_weather(name, weather)
	-- TODO: check and sanitize
	weather_mod.weathers[name] = weather
end

function weather_mod.set_weather(name)
	if type(weather_mod.weathers[name]) == nil then
		minetest.log("warning", "[Believable Weather] Weather does not exist")
		return
	end
	weather_mod.state.current_weather = name
end

local function is_outside(player, wind)
	local ppos = player:getpos()
	local wind_pos = vector.multiply(wind,-1)
	local skylight_pos = vector.add(ppos, vector.new(0, 40, 0))
	local downfall_origin = vector.add(skylight_pos,wind_pos)
	return weather_mod.is_outdoors(player, downfall_origin)
end

local function get_texture(particles)
	if type(particles.textures) == "nil" or next(particles.textures) == nil then
		return particles.texture
	end
	return particles.textures[math.random(#particles.textures)]
end

local function spawn_particles(player, particles, wind)
	local ppos = player:getpos()
	local wind_pos = vector.multiply(wind,-1)
	local wind_speed = vector.length(wind)

	local texture = get_texture(particles)

	local minp = vector.add(vector.add(ppos, particles.min_pos),wind_pos)
	local maxp = vector.add(vector.add(ppos, particles.max_pos),wind_pos)

	local vel = {x=wind.x,y=-particles.falling_speed,z=wind.z}
	local acc = {x=0, y=0, z=0}

	local exp = particles.exptime
	local vertical = wind_speed < 3

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

local sound_handles = {}
local function play_sound(player, sound)
	local playername = player:get_player_name()
	if not sound_handles[playername] then
		local handle = minetest.sound_play(sound, {
			to_player = playername,
			loop = true
		})
		if handle then
			sound_handles[playername] = handle
		end
	end
end

local function stop_sound(player)
	local playername = player:get_player_name()
	if sound_handles[playername] then
		minetest.sound_stop(sound_handles[playername])
		sound_handles[playername] = nil
	end
end

local function handle_weather()
	for _, player in ipairs(minetest.get_connected_players()) do
		local ppos = player:getpos()
		weather_mod.set_weather(weather_mod.get_weather(ppos, wind))

		if ppos.y < weather_mod.settings.min_height or ppos.y > weather_mod.settings.max_height then
			return
		end

		local weather = weather_mod.weathers[weather_mod.state.current_weather]
		local clouds = weather.clouds
		clouds.speed = vector.multiply(wind, 2)
		player:set_clouds(clouds)

		weather_mod.set_headwind(player, wind)
		--player:set_clouds({ density = 0.6, color = "#a4a0b6e5", speed = wind })

		local outdoors = is_outside(player, wind)
		if type(weather.particles) ~= "nil" and outdoors then
			spawn_particles(player, weather.particles, wind)
		end

		if type(weather.sound) ~= "nil" and outdoors then
			play_sound(player, weather.sound)
		else
			stop_sound(player)
		end
	end
end

local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer < GSCYCLE then return end
	timer = 0
	handle_weather()
end)