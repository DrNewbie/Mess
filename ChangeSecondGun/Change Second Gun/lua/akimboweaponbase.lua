function AkimboWeaponBase:create_second_gun(create_second_gun)
	local _other_one_unit = self._setup.user_unit:inventory():unit_by_selection(1)
	if _other_one_unit then
		local _factory_id = _other_one_unit:base()._factory_id
		if _factory_id and tweak_data.weapon.factory[_factory_id] then
			self._factory_id = _factory_id
			self._blueprint = _other_one_unit:base()._blueprint
			self._cosmetics_id = _other_one_unit:base()._cosmetics_id
			self._cosmetics_quality = _other_one_unit:base()._cosmetics_quality
			self._cosmetics_bonus = _other_one_unit:base()._cosmetics_bonus
		end
	end
	self:_create_second_gun(create_second_gun)
	self._setup.user_unit:camera()._camera_unit:link(Idstring("a_weapon_left"), self._second_gun, self._second_gun:orientation_object():name())
end