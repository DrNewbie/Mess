LegendaryArmours = LegendaryArmours or {}
Hooks:PostHook(NewRaycastWeaponBase, "replenish", "F_"..Idstring("NewRaycastWeaponBase:replenish:TogaHimikoLASBoosts"):key(), function(self)
	local las = tostring(managers.blackmarket:equipped_armor_skin())
	if LegendaryArmours[las] and las == "toga" then
		self.RofB_time = 8
		self.RofB_Min = 0.1
		self.RofB_Max = 16
		local ammax = self:get_ammo_max() * 10
		self:set_ammo_max(ammax)
		self:set_ammo_max_per_clip(ammax)
		self:set_ammo_total(ammax)
		call_on_next_update(function ()
			self:on_reload()
		end)
	end
end)