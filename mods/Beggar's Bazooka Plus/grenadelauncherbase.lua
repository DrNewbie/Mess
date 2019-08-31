Hooks:PostHook(GrenadeLauncherBase, "replenish", "F_"..Idstring("GrenadeLauncherBase:replenish:BB"):key(), function(self)
	if type(self._blueprint) == "table" and table.contains(self._blueprint, "wpn_fps_beggars_bazooka_body") then
		self._is_beggars_bazooka = true
	end
	if self._is_beggars_bazooka then
		self:set_ammo_max(999)
		self:set_ammo_max_per_clip(0)
		self:set_ammo_total(999)
		self.reload_speed_multiplier = function()
			return 1.75
		end
	end
end)

local old_fire = GrenadeLauncherBase.fire

function GrenadeLauncherBase:fire(...)
	if self._is_beggars_bazooka then
		return
	end
	return old_fire(self, ...)
end