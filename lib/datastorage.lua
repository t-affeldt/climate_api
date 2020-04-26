local state = minetest.get_mod_storage()

if not state:contains("noise_timer") then
	state:from_table({
		heat_random = 1,
		humidity_random = 1,
		humidity_base = 50,
		wind_x = 0.5,
		wind_z = 0.5,
		noise_timer = 0
	})
end

return state