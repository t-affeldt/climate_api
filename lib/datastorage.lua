local default_state = {
	heat = 1,
	humidity = 1,
	wind_x = 0.5,
	wind_z = 0.5,
	time_last_check = 0,
	time_current_day = 1
}

local state = minetest.get_mod_storage()

if not state:contains("time_last_check") then
	state:from_table({ fields = default_state })
end

return state