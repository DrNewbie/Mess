Hooks:PostHook(NewRaycastWeaponBase, "replenish", "F_"..Idstring("NewRaycastWeaponBase:replenish:mod that automatically refill minigun gun ammo"):key(), function(self)
	if table.contains(self:weapon_tweak_data().categories, "minigun") then
		self._is_auto_refill_minigun = true
	end
end)

Hooks:PostHook(NewRaycastWeaponBase, "add_ammo", "F_"..Idstring("NewRaycastWeaponBase:add_ammo:mod that automatically refill minigun gun ammo"):key(), function(self)
	if self._unit and alive(self._unit) and self._is_auto_refill_minigun and self:can_reload() then
		if self:clip_empty() then
			self:on_reload()
		else
			self._auto_refill_minigun_ask_forced_reload = TimerManager:game():time() + 0.3
		end
	end
end)