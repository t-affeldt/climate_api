local default_state = {
	heat = 1,
	humidity = 1,
	wind = vector.new(0, 0, -0.25),
	current_weather = "auto",
	time = {
		last_check = 0,
		day = 1
	}
}

local function use_datastorage()
	local state = datastorage.get(weather_mod.modname, "weather_state")
	for key, val in pairs(default_state) do
		if type(state[key]) == "nil" then
			state[key] = val
		end
	end
	return state
end

local function use_filesystem()
	local file_name = minetest.get_worldpath() .. "/" .. weather_mod.modname
	minetest.register_on_shutdown(function()
		local file = io.open(file_name, "w")
		file:write(minetest.serialize(weather_mod.state))
		file:close()
	end)

	local file = io.open(file_name, "r")
	if file ~= nil then
		local storage = minetest.deserialize(file:read("*a"))
		file:close()
		if type(storage) == "table" then
			return storage
		end
	end
	return default_state
end

function weather_mod.get_storage()
	local mod_datastorage = minetest.get_modpath("datastorage") ~= nil
	if mod_datastorage then
		return use_datastorage()
	else
		return use_filesystem()
	end
end
