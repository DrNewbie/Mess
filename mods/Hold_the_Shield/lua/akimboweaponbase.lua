function AkimboWeaponBase:create_second_gun(create_second_gun)
	self:_create_second_gun(create_second_gun)
	if self:is_this_able_to_shield() then
		if self._setup.user_unit:inventory():equipped_unit():base().AKIMBO then
			self:give_shield()
		end
	else
		self._setup.user_unit:camera()._camera_unit:link(Idstring("a_weapon_left"), self._second_gun, self._second_gun:orientation_object():name())
	end
end

function AkimboWeaponBase:give_shield()
	if not self:is_this_able_to_shield() then
		return
	end
	self:hide_shield()
	local _shield = "units/payday2/characters/ene_acc_shield_lights/ene_acc_shield_lights"
	self._shield_unit = World:spawn_unit(Idstring(_shield), Vector3(), Rotation())
	for i = 0, self._shield_unit:num_bodies() - 1 do
		self._shield_unit:body(i):set_keyframed(false)
		self._shield_unit:body(i):set_enabled(false)
	end	
	self:set_shield_unit(self._shield_unit)
	self._setup.user_unit:camera()._camera_unit:link(Idstring("a_weapon_left"), self._shield_unit, self._shield_unit:orientation_object():name())
end

function AkimboWeaponBase:hide_shield()
	return self._setup.user_unit:inventory():hide_shield()
end

function AkimboWeaponBase:set_shield_unit()
	self._setup.user_unit:inventory():set_shield_unit(self._shield_unit)
end

function AkimboWeaponBase:is_this_able_to_shield()
	return self._setup.user_unit:inventory():is_this_able_to_shield()
end

local _hts_AkimboWeaponBase_fire_second = AkimboWeaponBase._fire_second

function AkimboWeaponBase:_fire_second(...)
	if self._shield_unit and alive(self._shield_unit) then
		return
	end
	return _hts_AkimboWeaponBase_fire_second(self, ...)
end