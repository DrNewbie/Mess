Hooks:PreHook(RaycastWeaponBase, "on_reload", "LossAmmo_Attach_on_reload_Event", function(self)
	if self:can_reload() and tweak_data.weapon[self._name_id].reload_loss_ammo then
		local ammo_base = self._reload_ammo_base or self:ammo_base()
		if ammo_base then
			local ammo_in_clip = ammo_base:get_ammo_remaining_in_clip()
			local get_ammo_total = self:get_ammo_total()
			ammo_base:set_ammo_total(math.max(get_ammo_total - ammo_in_clip, 0))
		end
	end
end)