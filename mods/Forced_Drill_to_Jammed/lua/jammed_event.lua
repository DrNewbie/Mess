if Network:is_client() then
	return
end

Hooks:PostHook(TimerGui, "init", "ForcedDrillJammed_TimerGui_init", function(tim, ...)
	local _drill = tim._unit
	if _drill and alive(_drill) and _drill:base() and _drill:base().is_drill then
		tim._forced_delay_t = 0
	end
end)

Hooks:PostHook(TimerGui, "update", "ForcedDrillJammed_TimerGui_update", function(tim, unit, t, dt)
	local _drill = tim._unit
	if _drill and alive(_drill) and _drill:base() and _drill:base().is_drill and not tim._jammed and t > tim._forced_delay_t then
		tim._forced_delay_t = t + 1
		_drill:timer_gui():set_jammed(true)
	end
end)