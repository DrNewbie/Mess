Hooks:PreHook(PlayerStandard, "_start_action_reload", "F_"..Idstring("PreHook:PlayerStandard:_start_action_reload:All reloads are empty mag reloads"):key(), function(self)
	local weapon = self._equipped_unit:base()
	if weapon and weapon:can_reload() and not self:_is_reloading() then
		weapon:set_ammo_remaining_in_clip(0)
	end
end)