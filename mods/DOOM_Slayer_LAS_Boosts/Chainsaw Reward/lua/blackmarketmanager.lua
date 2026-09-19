function BlackMarketManager:apply_fake_equipped_melee_weapon(melee_id)
	self._fake_equipped_melee_weapon = melee_id
end

local Use_Bonus_Cut_Melee = BlackMarketManager.equipped_melee_weapon

function BlackMarketManager:equipped_melee_weapon(...)
	if self._fake_equipped_melee_weapon then return self._fake_equipped_melee_weapon end
	return Use_Bonus_Cut_Melee(self, ...)
end