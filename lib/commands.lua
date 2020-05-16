-- parse heat values into readable format
-- also convert to Celsius if configured
local function parse_heat(heat)
	local indicator = "°F"
	if not climate_mod.settings.fahrenheit then
		heat = (heat - 32) * 5 / 9
		indicator = "°C"
	end
	heat = math.floor(heat * 100) / 100
	return heat .. indicator
end


-- register weather privilege in order to modify the weather status
minetest.register_privilege("weather", {
	description = "Make changes to the current weather",
	give_to_singleplayer = false
})

-- display general information on current weather
minetest.register_chatcommand("weather", {
	description ="Display weather information",
	func = function(playername)
		local player = minetest.get_player_by_name(playername)
		local ppos = player:get_pos()
		local weathers = climate_api.environment.get_weather_presets(player)
		local effects = climate_api.environment.get_effects(player)
		local heat = climate_api.environment.get_heat(ppos)
		local humidity = math.floor(climate_api.environment.get_humidity(ppos) * 100) / 100
		local msg = ""
		if #weathers > 0 then
			msg = msg .. "The following weather presets are active for you: "
			for _, weather in ipairs(weathers) do
				msg = msg .. weather .. ", "
			end
			msg = msg:sub(1, #msg-2) .. "\n"
		else
			msg = msg .. "Your sky is clear. No weather presets are currently active.\n"
		end
		if #effects > 0 then
			msg = msg .. "As a result, the following environment effects are applied: "
			for _, effect in ipairs(effects) do
				msg = msg .. effect .. ", "
			end
			msg = msg:sub(1, #msg-2) .. "\n"
		end
		local heat_desc
		if heat > 80 then heat_desc = "scorching"
		elseif heat > 50 then heat_desc = "pleasant"
		else heat_desc = "chilly" end
		msg = msg .. "It is a " .. heat_desc .. " " .. parse_heat(heat) .. " right now and "
		msg = msg .. "humidity is at " .. humidity .. "%.\n"
		minetest.chat_send_player(playername, msg)
	end
})

-- set base heat to increase or decrease global climate temperatures
minetest.register_chatcommand("set_base_heat", {
	params = "<heat>",
	description = "Override the weather algorithm's base heat",
	privs = { weather = true },
	func = function(playername, param)
		if param == nil or param == "" then
			minetest.chat_send_player(playername, "Provide a number to modify the base heat")
			return
		end
		if param == "auto" then param = 0 end
		climate_mod.settings.heat = tonumber(param) or 0
		minetest.chat_send_player(playername, "Base heat changed")
	end
})

-- override global heat levels with given value
minetest.register_chatcommand("set_heat", {
	params = "<heat>",
	description = "Override the weather algorithm's base heat",
	privs = { weather = true },
	func = function(playername, param)
		if param == nil or param == "" then
			minetest.chat_send_player(playername, "Provide a number to modify the base heat")
			return
		end
		if param == "auto" then
			climate_mod.forced_enviroment.heat = nil
			minetest.chat_send_player(playername, "Heat value reset")
		else
			climate_mod.forced_enviroment.heat = tonumber(param) or 0
			minetest.chat_send_player(playername, "Heat value changed")
		end
	end
})

-- set base heat to increase or decrease global climate humidity
minetest.register_chatcommand("set_base_humidity", {
	params = "<humidity>",
	description = "Override the weather algorithm's base humidity",
	privs = { weather = true },
	func = function(playername, param)
		if param == "auto" then param = 0 end
		if param == nil or param == "" then
			minetest.chat_send_player(playername, "Provide a number to modify the base humidity")
			return
		end
		climate_mod.settings.humidity = tonumber(param) or 0
		minetest.chat_send_player(playername, "Base humidity changed")
	end
})

-- override global humidity with given value
minetest.register_chatcommand("set_humidity", {
	params = "<humidity>",
	description = "Override the weather algorithm's base humidity",
	privs = { weather = true },
	func = function(playername, param)
		if param == nil or param == "" then
			minetest.chat_send_player(playername, "Provide a number to modify the base humidity")
			return
		end
		if param == "auto" then
			climate_mod.forced_enviroment.humidity = nil
			minetest.chat_send_player(playername, "Humidity value reset")
		else
			climate_mod.forced_enviroment.humidity = tonumber(param) or 0
			minetest.chat_send_player(playername, "Humidity value changed")
		end
	end
})

-- override wind direction and speed with given values
minetest.register_chatcommand("set_wind", {
	params = "<wind>",
	description = "Override the weather algorithm's windspeed",
	privs = { weather = true },
	func = function(playername, param)
		if param == nil or param == "" then
			minetest.chat_send_player(playername, "Provide a number to modify the base humidity")
			return
		end
		local arguments = {}
		for w in param:gmatch("%S+") do table.insert(arguments, w) end
		local arg1 = arguments[1]
		local wind_x = tonumber(arguments[1])
		local wind_z = tonumber(arguments[2])
		if arg1 == "auto" then
			climate_mod.forced_enviroment.wind = nil
			minetest.chat_send_player(playername, "Wind reset")
		elseif wind_x == nil or wind_z == nil then
			minetest.chat_send_player(playername, "Invalid wind configuration")
		else
			climate_mod.forced_enviroment.wind = vector.new({
				x = wind_x,
				y = 0,
				z = wind_z
			})
			minetest.chat_send_player(playername, "Wind changed")
		end
	end
})

-- display current mod config
minetest.register_chatcommand("weather_settings", {
	description = "Print the active Climate API configuration",
	func = function(playername)
		minetest.chat_send_player(playername, "Current Settings\n================")
		for setting, value in pairs(climate_mod.settings) do
			minetest.chat_send_player(playername, dump2(value, setting))
		end
	end
})

-- force a weather preset or disable it
minetest.register_chatcommand("set_weather", {
	params ="<weather> <status>",
	description ="Turn the specified weather preset on or off for all players or reset it to automatic",
	privs = { weather = true },
	func = function(playername, param)
		local arguments = {}
		for w in param:gmatch("%S+") do table.insert(arguments, w) end
		local weather = arguments[1]
		if weather == nil or climate_mod.weathers[weather] == nil then
			minetest.chat_send_player(playername, "Unknown weather preset")
			return
		end
		local status
		if arguments[2] == nil or arguments[2] == "" then
			arguments[2] = "on"
		end
		if arguments[2] == "on" then
			status = true
		elseif arguments[2] == "off" then
			status = false
		elseif arguments[2] == "auto" then
			status = nil
		else
			minetest.chat_send_player(playername, "Invalid weather status. Set the preset to either on, off or auto.")
			return
		end
		climate_mod.forced_weather[weather] = status
		minetest.chat_send_player(playername, "Weather " .. weather .. " successfully set to " .. arguments[2])
	end
})

-- list all weather presets and whether they have been forced or disabled
minetest.register_chatcommand("weather_status", {
	description = "Prints which weather presets are enforced or disabled",
	func = function(playername)
		minetest.chat_send_player(playername, "Current activation rules:\n================")
		for weather, _ in pairs(climate_mod.weathers) do
			local status = "auto"
			if climate_mod.forced_weather[weather] == true then
				status = "on"
			elseif climate_mod.forced_weather[weather] == false then
				status = "off"
			end
			minetest.chat_send_player(playername, dump2(status, weather))
		end
	end
})

-- show all environment influences and their values for the executing player
minetest.register_chatcommand("weather_influences", {
	description = "Prints which weather influences cause your current weather",
	func = function(playername)
		minetest.chat_send_player(playername, "Current influences rules:\n================")
		local player = minetest.get_player_by_name(playername)
		local influences = climate_mod.trigger.get_player_environment(player)
		for influence, value in pairs(influences) do
			minetest.chat_send_player(playername, dump2(value, influence))
		end
	end
})