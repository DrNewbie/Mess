dofile("mods/Armor Skins Boosts/Load.lua")

local visibility_modifiers = BlackMarketManager.visibility_modifiers
function BlackMarketManager:visibility_modifiers(...)
	local ADD_NUM = Get_Current_ArmorSkinsBoosts("concealment")
	return visibility_modifiers(self, ...) + ADD_NUM
end

local concealment_modifier = BlackMarketManager.concealment_modifier
function BlackMarketManager:concealment_modifier(type, ...)
	local ADD_NUM = 0
	if type == "armors" then
		ADD_NUM = Get_Current_ArmorSkinsBoosts("concealment")
	end
	return concealment_modifier(self, type, ...) + ADD_NUM
end