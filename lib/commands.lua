minetest.register_privilege("weather", {
	description = "Change the weather",
	give_to_singleplayer = false
})

minetest.register_chatcommand("date", {
	func = function(playername, param)
		local date = weather_mod.print_date()
		minetest.chat_send_player(playername, date)
	end
})

-- Force a weather effect to override environment
minetest.register_chatcommand("set_weather", {
	params = "<weather>",
	description = "Set weather to a registered type of effect\
		show all types when no parameters are given", -- full description
	privs = {weather = true},
	func = function(name, param)
		if param == nil or param == "" or param == "?" then
			local types="auto"
			for i,_ in pairs(weather_mod.weathers) do
				types=types..", "..i
			end
			minetest.chat_send_player(name, "avalible weather types: "..types)
		else
			if type(weather_mod.weathers[param]) == "nil" and param ~= "auto" then
				minetest.chat_send_player(name, "This type of weather is not registered.\n"..
					"To list all types of weather run the command without parameters.")
			else
				weather_mod.state.current_weather = param
			end
		end
	end
})

-- Set wind speed and direction
minetest.register_chatcommand("set_wind", {
	params = "<wind>",
	description = "Set wind to the given x,z direction", -- full description
	privs = {weather = true},
	func = function(name, param)
		if param==nil or param=="" then
			minetest.chat_send_player(name, "please provide two comma seperated numbers")
			return
		end
		local x,z = string.match(param, "^([%d.-]+)[, ] *([%d.-]+)$")
		x=tonumber(x)
		z=tonumber(z)
		if x and z then
			weather_mod.state.wind = vector.new(x,0,z)
		else
			minetest.chat_send_player(name, param.." are not two comma seperated numbers")
		end
	end
})

-- Set base value of global heat level
minetest.register_chatcommand("set_heat", {
	params = "<heat>",
	description = "Set base value of global heat level", -- full description
	privs = {weather = true},
	func = function(name, param)
		if param==nil or param=="" then
			minetest.chat_send_player(name, "please provide a heat value")
			return
		end
		v = tonumber(param)
		if v then
			weather_mod.state.heat = v
		else
			minetest.chat_send_player(name, param.." is not a valid heat level")
		end
	end
})

-- Set base value of global humidity level
minetest.register_chatcommand("set_humidity", {
	params = "<humidity>",
	description = "Set base value of global humidity level", -- full description
	privs = {weather = true},
	func = function(name, param)
		if param==nil or param=="" then
			minetest.chat_send_player(name, "please provide a humidity value")
			return
		end
		v = tonumber(param)
		if v then
			weather_mod.state.humidity = v
		else
			minetest.chat_send_player(name, param.." is not a valid humidity level")
		end
	end
})