if Network and not Network:is_server() then
	return
end

Hooks:PostHook(SawHit, "on_collision", "F_"..Idstring("SawHit:on_collision:UseSaw2ImproveOtherSaw"):key(), function(self, col_ray, weapon_unit, user_unit, damage)
	local hit_unit = col_ray and col_ray.unit or nil
	if hit_unit and hit_unit:base() then
		if hit_unit:name():key() == "0cec8292d88a4875" or hit_unit:name() == Idstring("units/pd2_dlc_jolly/equipment/gen_interactable_saw/gen_interactable_saw") then
			if hit_unit:timer_gui() and type(hit_unit:timer_gui()._current_timer) == "number" and hit_unit:timer_gui()._current_timer > 1 then
				hit_unit:timer_gui()._current_timer = hit_unit:timer_gui()._current_timer - damage * 0.3
			end
		end
	end
end)