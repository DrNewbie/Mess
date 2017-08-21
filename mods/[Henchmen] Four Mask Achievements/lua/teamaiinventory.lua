_G.FourMaskAchievements = _G.FourMaskAchievements or {}
FourMaskAchievements.Mask = FourMaskAchievements.Mask or {}

function TeamAIInventory:preload_mask()
	local character_name = managers.criminals:character_name_by_unit(self._unit)
	local mask_unit_name = managers.criminals:character_data_by_name(character_name).mask_obj
	mask_unit_name = mask_unit_name[Global.level_data.level_id] or mask_unit_name.default or mask_unit_name
	self._mask_unit_name = mask_unit_name
	for mask_name, mask_data in pairs(tweak_data.blackmarket.masks) do 
		if mask_data and mask_data.unit == mask_unit_name then
			FourMaskAchievements.Mask[self._unit:name():key()] = mask_name
			break
		end
	end
	managers.dyn_resource:load(Idstring("unit"), Idstring(mask_unit_name), managers.dyn_resource.DYN_RESOURCES_PACKAGE, callback(self, self, "clbk_mask_unit_loaded"))
end