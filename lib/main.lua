local GSCYCLE = 0.01
local WORLD_CYCLE = 0.5

local gs_timer = 0
local world_timer = 0
minetest.register_globalstep(function(dtime)
	gs_timer = gs_timer + dtime
	world_timer = world_timer + dtime

	if gs_timer + dtime < GSCYCLE then return else gs_timer = 0 end

	if world_timer >= WORLD_CYCLE then
		local noise_timer = climate_mod.state:get_float("noise_timer") + world_timer
		world_timer = 0
		climate_mod.state:set_float("noise_timer", noise_timer)
		climate_mod.world.update_status(noise_timer)
	end

	climate_mod.current_effects = climate_mod.trigger.get_active_effects()

	for name, effect in pairs(climate_mod.effects) do
		if climate_mod.cycles[name].timespan < climate_mod.cycles[name].timer + dtime then
			climate_mod.cycles[name].timer = 0
			climate_mod.trigger.call_handlers(name, climate_mod.current_effects[name])
		else
			climate_mod.cycles[name].timer = climate_mod.cycles[name].timer + dtime
		end
	end
end)