LegendaryArmours = LegendaryArmours or {}

Hooks:PostHook(NewRaycastWeaponBase, "replenish", "F_"..Idstring("PostHook:NewRaycastWeaponBase:replenish:NepgearLASBoosts"):key(), function(self)
	if managers.player and managers.player:Is_LAS_Nepgear() then
		self:set_ammo_max(0)
		self:set_ammo_max_per_clip(0)
		self:set_ammo_total(0)
		call_on_next_update(function ()
			self:on_reload()
		end)
	end
end)