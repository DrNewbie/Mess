Hooks:PostHook(BlackMarketTweakData, "_init_masks", "alt_sydney_bm_init_masks", function(self, tweak_data)
	self.masks.character_locked.sydney_alt = "sydney"
	for mask_id, mask_data in pairs(self.masks) do
		for type_id in pairs({"characters", "offsets"}) do
			if mask_data[type_id] and mask_data[type_id].sydney then
				self.masks[mask_id][type_id].sydney_alt = deep_clone(mask_data[type_id].sydney)
			end
		end
	end
end)