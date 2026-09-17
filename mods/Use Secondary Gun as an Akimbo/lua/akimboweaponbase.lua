local ThisModPath = tostring(ModPath)
local ThisModIds = Idstring(ThisModPath):key()

local __Name = function(__id)
	return "K_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end

local old_factory_id, old_blueprint, old_cosmetics, old_cosmetics_quality, old_cosmetics_bonus

Hooks:PreHook(AkimboWeaponBase, "create_second_gun", __Name(1), function(self, ...)
	local __other_one_unit = self._setup.user_unit:inventory():unit_by_selection(1)
	if __other_one_unit then
		local this_factory_id = __other_one_unit:base()._factory_id
		if this_factory_id and tweak_data.weapon.factory[this_factory_id] then
			old_factory_id = self._factory_id
			self._factory_id = this_factory_id
			
			old_blueprint = self._blueprint
			self._blueprint = __other_one_unit:base()._blueprint
			
			old_cosmetics = self._cosmetics
			self._cosmetics = __other_one_unit:base()._cosmetics
			
			old_cosmetics_quality = self._cosmetics_quality
			self._cosmetics_quality = __other_one_unit:base()._cosmetics_quality
			
			old_cosmetics_bonus = self._cosmetics_bonus
			self._cosmetics_bonus = __other_one_unit:base()._cosmetics_bonus			
		end
	end
end)

Hooks:PostHook(AkimboWeaponBase, "create_second_gun", __Name(2), function(self, ...)
	if old_factory_id then
		self._factory_id = old_factory_id			
		self._blueprint = old_blueprint			
		self._cosmetics_id = old_cosmetics			
		self._cosmetics_quality = old_cosmetics_quality			
		self._cosmetics_bonus = old_cosmetics_bonus
		
		old_factory_id, old_blueprint, old_cosmetics, old_cosmetics_quality, old_cosmetics_bonus = nil, nil, nil, nil, nil
	end
end)