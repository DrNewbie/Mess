Hooks:PostHook(BlackMarketTweakData, "_init_projectiles", "M202Incen_BlackMarketTweakData_init_projectiles", function(self, tweak_data)
	self.projectiles.rocket_ray_frag_incen = deep_clone(self.projectiles.rocket_ray_frag)
	self.projectiles.rocket_ray_frag_incen.unit = "units/mods/weapons/wpn_third_ray_fired_rocket/wpn_third_ray_fired_incen_rocket"
	if not table.contains(self._projectiles_index, 'rocket_ray_frag_incen') then
		table.insert(self._projectiles_index, 'rocket_ray_frag_incen')
	end
	local free_dlcs = tweak_data:free_dlc_list()
	for _, data in pairs(self.projectiles) do
		if free_dlcs[data.dlc] then
			data.dlc = nil
		end
	end
	self:_add_desc_from_name_macro(self.projectiles)
end)