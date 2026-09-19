local old_health_skill_multiplier = PlayerManager.health_skill_multiplier

function PlayerManager:health_skill_multiplier(...)
	local equipped_mask = managers.blackmarket:equipped_mask()
	mask_id = equipped_mask and equipped_mask.mask_id
	if mask_id and mask_id == "toon_04" then
		return old_health_skill_multiplier(self, ...) * 1.2	
	end
	return old_health_skill_multiplier(self, ...)
end
