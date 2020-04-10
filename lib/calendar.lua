function weather_mod.get_time_heat()
	local time = minetest.get_timeofday()
	return math.cos((2 * time + 1) * math.pi) / 3 + 1
end

function weather_mod.get_calendar_heat()
	-- European heat center in August instead of June
	local progression = (weather_mod.state.time.day + 61) / 365
	return math.cos((2 * progression + 1) * math.pi) / 3 + 1
end

function weather_mod.handle_time_progression()
	local time = minetest.get_timeofday()
	if time < weather_mod.state.time.last_check then
		weather_mod.state.time.day = weather_mod.state.time.day + 1
	end
	weather_mod.state.time.last_check = time
end