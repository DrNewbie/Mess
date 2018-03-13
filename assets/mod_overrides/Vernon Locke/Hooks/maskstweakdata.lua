Hooks:PostHook(BlackMarketTweakData, "_init_masks", "locke_player_bm_init_masks", function(self, tweak_data)
	self.masks.character_locked.locke_player = "nyck_beret"
	for mask_id, mask_data in pairs(self.masks) do
		for type_id in pairs({"characters", "offsets"}) do
			if mask_data[type_id] and mask_data[type_id].locke_player then
				self.masks[mask_id][type_id].locke_player = deep_clone(mask_data[type_id].locke_player)
			end
		end
	end
end)