local function parse_heat(heat)
	local indicator = "°F"
	if not climate_mod.settings.fahrenheit then
		heat = (heat - 32) * 5 / 9
		indicator = "°C"
	end
	heat = math.floor(heat * 100) / 100
	return heat .. indicator
end

minetest.register_privilege("weather", {
	description = "Make changes to the current weather",
	give_to_singleplayer = false
})

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

minetest.register_chatcommand("set_heat", {
	params = "<heat>",
	description = "Override the weather algorithm's base heat",
	privs = { weather = true },
	func = function(playername, param)
		if param == nil or param == "" then
			minetest.chat_send_player(playername, "Provide a number to modify the base heat")
			return
		end
		climate_mod.settings.heat = tonumber(param)
		minetest.chat_send_player(playername, "Heat changed")
	end
})

minetest.register_chatcommand("set_humidity", {
	params = "<humidity>",
	description = "Override the weather algorithm's base humidity",
	privs = { weather = true },
	func = function(playername, param)
		if param == nil or param == "" then
			minetest.chat_send_player(playername, "Provide a number to modify the base humidity")
			return
		end
		climate_mod.settings.humidity = tonumber(param)
		minetest.chat_send_player(playername, "Humidity changed")
	end
})

minetest.register_chatcommand("weather_settings", {
	description = "Print the active Climate API configuration",
	privs = { weather = true },
	func = function(playername)
		minetest.chat_send_player(playername, "Current Settings\n================")
		for setting, value in pairs(climate_mod.settings) do
			minetest.chat_send_player(playername, dump2(value, setting))
		end
	end
})