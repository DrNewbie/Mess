Hooks:PostHook(NewRaycastWeaponBase, "fire", "WPN_"..Idstring("time to give flame 1"):key(), function(self)
	if alive(self._unit) and self._unit:base()._blueprint and table.contains(self._unit:base()._blueprint, "wpn_fps_lmg_canton_body") then
		managers.player:GiveRingOfFlames()
	end
end)

Hooks:PostHook(NewRaycastWeaponBase, "fire", "WPN_"..Idstring("time to give flame 2"):key(), function(self)
	if alive(self._unit) and self._unit:base()._blueprint and table.contains(self._unit:base()._blueprint, "wpn_fps_lmg_canton_body") then
		managers.player:GiveRingOfFlames()
	end
end)