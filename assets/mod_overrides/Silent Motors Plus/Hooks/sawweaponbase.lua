Hooks:PostHook(SawWeaponBase, "setup", "F_"..Idstring("PostHook:SawWeaponBase:setup:Silent Motors Plus"):key(), function(self)
	if type(self._blueprint) == "table" and table.contains(self._blueprint, "wpn_fps_saw_body_silent_plus") then
		self._no_hit_alert_size = 0.2
		self._hit_alert_size = 0.1
	end
end)