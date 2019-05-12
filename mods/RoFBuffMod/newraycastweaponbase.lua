Hooks:PostHook(NewRaycastWeaponBase, "_update_stats_values", "RofBuffAddonAttachInit", function(self)
	self.RofB_time = self.RofB_time or 1
	self.RofB_Min = self.RofB_Min or 1
	self.RofB_Max = self.RofB_Max or 1
	local custom_stats = managers.weapon_factory:get_custom_stats_from_weapon(self._factory_id, self._blueprint)
	for part_id, stats in pairs(custom_stats) do
		if stats.RofB_time then
			self.RofB_time = self.RofB_time * stats.RofB_time
		end
		if stats.RofB_Min then
			self.RofB_Min = self.RofB_Min * stats.RofB_Min
		end
		if stats.RofB_Max then
			self.RofB_Max = self.RofB_Max * stats.RofB_Max
		end
	end
	if self.RofB_Min == self.RofB_Max then
		self.RofB_time = nil
		self.RofB_Min = nil
		self.RofB_Max = nil
	end
end)