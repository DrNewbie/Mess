Hooks:PreHook(NewRaycastWeaponBase, 'fire', 'F_'..Idstring('PreHook:NewRaycastWeaponBase:fire:XP Bullet (Weapon Mod)'):key(), function(self)
	if table.contains(self._blueprint, "wpn_fps_mws_xp_bullet") then
		managers.experience:mission_xp_award(
			managers.experience:mission_xp() * 0.01
		)
	end
end)