_G.SentryGunModeFUN = _G.SentryGunModeFUN or {}
SentryGunModeFUN = _G.SentryGunModeFUN or {}
SentryGunModeFUN.Record = SentryGunModeFUN.Record or {}

Hooks:PostHook(SentryGunBrain, "update", "SentryGunModeFUN_update", function(self, unit, t, dt)
	if self._unit:base() and self._unit:base()._switch_mode_dt and type(self._unit:base()._switch_mode_dt) == "number" then
		self._unit:base()._switch_mode_dt = self._unit:base()._switch_mode_dt - dt
		if self._unit:base()._switch_mode_dt < 0 then
			self._unit:base()._switch_mode_dt = nil
		end
	end
end)

local SentryGunModeFUN_is_target_on_sight = SentryGunBrain.is_target_on_sight

function SentryGunBrain:is_target_on_sight(my_pos, target_base_pos, ...)
	if self._unit:base() then
		if self._unit:base()._switch_mode_dt then
			return false
		end
		if self._unit:base()._switch_mode and self._unit:base()._switch_mode > 0 then
			return false
		end
	end
	return SentryGunModeFUN_is_target_on_sight(self, my_pos, target_base_pos, ...)
end