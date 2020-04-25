local api = {}

api.SHORT_CYCLE		= 0.03	-- for particles and fast animations
api.DEFAULT_CYCLE	=  0.1	-- for most effect types
api.MEDIUM_CYCLE	=	 2.0	-- for ressource intensive tasks
api.LONG_CYCLE		=  5.0	-- for write operations and skybox changes

function api.register_weather(name, conditions, effects)
	-- TODO: check and sanitize
	climate_mod.weathers[name] = {
		conditions = conditions,
		effects = effects,
		active_players = {}
	}
end

function api.register_effect(name, handler, htype)
	-- check for valid handler types
	if htype ~= "start" and htype ~= "tick" and htype ~= "stop" then
		minetest.log("warning", "[Climate API] Effect " .. dump(name) .. " uses invalid callback type: " .. dump(htype))
		return
	end
	-- create effect handler registry if not existent yet
	if type(climate_mod.effects[name]) == "nil" then
		climate_mod.effects[name] = { start = {}, tick = {}, stop = {} }
		climate_mod.cycles[name] = { timespan = api.DEFAULT_CYCLE, timer = 0 }
	end
	-- store effect handler
	table.insert(climate_mod.effects[name][htype], handler)
end

function api.set_effect_cycle(name, cycle)
	climate_mod.cycles[name].timespan = cycle
end

function api.register_global_influence(name, func)
	climate_mod.global_influences[name] = func
end

function api.register_influence(name, func)
	climate_mod.influences[name] = func
end

function api.register_abm(config)
	if not climate_mod.settings.block_updates then return end

	local conditions = config.conditions
	local action = config.action
	local pos_override = config.pos_override

	local override = function(pos, node)
		local env = climate_mod.trigger.get_position_environment(pos)
		if type(pos_override) == "function" then
			pos = pos_override(pos)
		end

		if conditions == nil then
			return action(pos, node, env)
		end

		for condition, goal in pairs(conditions) do
			local is_applicable = climate_mod.trigger.test_condition(condition, env, goal)
			if not is_applicable then return end
		end
		return action(pos, node, env)
	end

	config.conditions = nil
	config.action = override
	minetest.register_abm(config)
end

return api
