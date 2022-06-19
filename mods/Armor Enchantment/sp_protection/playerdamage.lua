local func1 = _G.EEArmorBuffMain.__Name("sp_protection::func1")

PlayerManager[func1] = PlayerManager[func1] or PlayerManager.damage_reduction_skill_multiplier

function PlayerManager:damage_reduction_skill_multiplier(...)
	local sp_protection_now = self:__EE_Armor_Get_Var_by_Lv_and_ID(nil, 6)
	local __Ans = self[func1](self, ...)
	if __Ans > 0 and self:player_unit() and self:player_unit():character_damage():get_real_armor() > 0 and type(sp_protection_now) == "number" and (sp_protection_now > 0 or sp_protection_now < 0) then
		__Ans = __Ans * (1 - sp_protection_now / 100)
	end
	return __Ans
end