local ThisModPath = ModPath
local Hook1 = "EEA_"..Idstring("upgrade_value::"..ThisModPath):key()

PlayerManager[Hook1] = PlayerManager[Hook1] or PlayerManager.upgrade_value

function PlayerManager:upgrade_value(category, upgrade, ...)
	local Ans = self[Hook1](self, category, upgrade, ...)
	if category == "player" and upgrade == "armor_regen_time_mul" then
		Ans = Ans - self:__EE_Armor_Get_Var_by_Lv_and_ID(nil, 1)/100
		Ans = math.max(Ans, 0.001)
	elseif category == "player" and upgrade == "armor_multiplier" then
		Ans = Ans + self:__EE_Armor_Get_Var_by_Lv_and_ID(nil, 2)/100
	elseif category == "player" and upgrade == "passive_dodge_chance" then
		Ans = Ans + self:__EE_Armor_Get_Var_by_Lv_and_ID(nil, 3)/100
	elseif category == "player" and upgrade == "stamina_multiplier" then
		Ans = Ans + self:__EE_Armor_Get_Var_by_Lv_and_ID(nil, 4)/100
	elseif category == "player" and upgrade == "movement_speed_multiplier" then
		Ans = Ans + self:__EE_Armor_Get_Var_by_Lv_and_ID(nil, 8)/100
	elseif category == "carry" and upgrade == "movement_speed_multiplier" then
		Ans = Ans + self:__EE_Armor_Get_Var_by_Lv_and_ID(nil, 9)/100
	end
	return Ans
end