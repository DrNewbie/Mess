local NepgearLASBoostsMeleeChargeSpeedBoost = PlayerStandard._get_melee_charge_lerp_value

function PlayerStandard:_get_melee_charge_lerp_value(...)
	if managers.player and managers.player:Is_LAS_Nepgear() then
		return 1
	else
		return NepgearLASBoostsMeleeChargeSpeedBoost(self, ...)
	end
end

Hooks:PostHook(PlayerStandard, "_do_melee_damage", "F_"..Idstring("PostHook:PlayerStandard:_do_melee_damage:NepgearLASBoosts"):key(), function(self, t, bayonet_melee, melee_hit_ray)
	if self._state_data and managers.player and managers.player:Is_LAS_Nepgear() then
		local _prec = 0.50
		local _melee_id = managers.blackmarket:equipped_melee_weapon()
		local _melee_tweak = tweak_data.blackmarket.melee_weapons[_melee_id]
		local _expire_t = _melee_tweak.expire_t or 0
		local _repeat_expire_t = _melee_tweak.repeat_expire_t or 0		
		local r_expire_t = _expire_t * _prec
		local r_repeat_expire_t = _repeat_expire_t * _prec
		if self._state_data.melee_expire_t then
			self._state_data.melee_expire_t = self._state_data.melee_expire_t - r_expire_t
		end
		if self._state_data.melee_repeat_expire_t then
			self._state_data.melee_repeat_expire_t = self._state_data.melee_repeat_expire_t - r_repeat_expire_t
		end
	end
end)