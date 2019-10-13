Hooks:PostHook(NewRaycastWeaponBase, "replenish", "F_"..Idstring("NewRaycastWeaponBase:replenish:DewmSlayaLASBoosts"):key(), function(self)
	if managers.player:Is_LAS_DewmSlaya() then
		local ammax = self:get_ammo_max() * 2
		self:set_ammo_max(ammax)
		if self:weapon_tweak_data().CLIP_AMMO_MAX == 2 and table.contains(self:weapon_tweak_data().categories, "shotgun") and self:weapon_tweak_data().upgrade_blocks and self:weapon_tweak_data().upgrade_blocks.weapon and table.contains(self:weapon_tweak_data().upgrade_blocks.weapon, "clip_ammo_increase") then
			self._is_super_shotgun_type = true
		else
			self:set_ammo_max_per_clip(ammax)
		end
		self:set_ammo_total(ammax)
		self._is_dewmslaya = true
	end
end)

Hooks:PostHook(NewRaycastWeaponBase, "add_ammo", "F_"..Idstring("NewRaycastWeaponBase:add_ammo:DewmSlayaLASBoosts"):key(), function(self)
	if self._unit and alive(self._unit) and not self._is_super_shotgun_type and managers.player:Is_LAS_DewmSlaya() and self:can_reload() then
		if self:clip_empty() then
			self:on_reload()
		else
			self._ask_forced_reload = TimerManager:game():time() + 0.5
		end
	end
end)