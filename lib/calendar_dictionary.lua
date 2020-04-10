weather_mod.weekdays = {
	"Monday",
	"Tuesday",
	"Wednesday",
	"Thursday",
	"Friday",
	"Saturday",
	"Sunday"
}

weather_mod.months = {
	{ name = "January", days = 31 },
	{ name = "February", days = 28 },
	{ name = "March", days = 31 },
	{ name = "April", days = 30 },
	{ name = "May", days = 31 },
	{ name = "June", days = 30 },
	{ name = "July", days = 31 },
	{ name = "August", days = 31 },
	{ name = "September", days = 30 },
	{ name = "October", days = 31 },
	{ name = "November", days = 30 },
	{ name = "December", days = 31 }
}

weather_mod.seasons = {
	{ name = "spring" },
	{ name = "summer" },
	{ name = "autumn" },
	{ name = "winter" }
}

function weather_mod.get_weekday()
	return (weather_mod.state.time.day - 1) % 7 + 1
end

function weather_mod.get_month()
	local day = (weather_mod.state.time.day - 1) % 365 + 1
	local sum = 0
	for i, month in ipairs(weather_mod.months) do
		sum = sum + month.days
		if sum >= day then
			return i
		end
	end
end

function weather_mod.get_season()
	local month = weather_mod.get_month()
	return math.floor((month - 1) / 3 + 1)
end

function weather_mod.print_date()
	local weekday = weather_mod.weekdays[weather_mod.get_weekday()]
	local date = (weather_mod.state.time.day - 1) % 365 + 1
	local month = weather_mod.months[weather_mod.get_month()].name
	return weekday .. ", " .. date .. ". " .. month
end