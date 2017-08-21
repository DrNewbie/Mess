if Network:is_client() then
	return
end

Hooks:PostHook(TimerGui, "update", "RemoveDrill_TimerGui_update", function(tim, unit, t, dt)
	local _drill = tim._unit
	if _drill and alive(_drill) and _drill:base() and _drill:base().is_drill and not tim._jammed then
		if not _drill:interaction():active() then
			if _drill:interaction() then
				if tim._jammed_tweak_data then
					tim._unit:interaction():set_tweak_data(tim._jammed_tweak_data)
				end
				_drill:interaction():set_active(true, false)
			end
		end
	end
end)