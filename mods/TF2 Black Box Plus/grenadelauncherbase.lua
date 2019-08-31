Hooks:PostHook(GrenadeLauncherBase, "replenish", "F_"..Idstring("GrenadeLauncherBase:replenish:wpn_fps_black_box_body"):key(), function(self)
	if type(self._blueprint) == "table" and table.contains(self._blueprint, "wpn_fps_black_box_body") then
		self._is_black_box = true
	end
	if self._is_black_box then
		self:set_ammo_max(200)
		self:set_ammo_total(200)
		self.reload_speed_multiplier = function()
			return 1.25
		end
	end
end)