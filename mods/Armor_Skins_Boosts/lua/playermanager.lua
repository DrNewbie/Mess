dofile("mods/Armor Skins Boosts/Load.lua")

local body_armor_skill_multiplier = PlayerManager.body_armor_skill_multiplier
function PlayerManager:body_armor_skill_multiplier(...)
	local ADD_NUM = Get_Current_ArmorSkinsBoosts("armor")
	return body_armor_skill_multiplier(self, ...) + ADD_NUM
end

local stamina_multiplier = PlayerManager.stamina_multiplier
function PlayerManager:stamina_multiplier(...)
	local ADD_NUM = Get_Current_ArmorSkinsBoosts("stamina")
	return stamina_multiplier(self, ...) + ADD_NUM
end

local skill_dodge_chance = PlayerManager.skill_dodge_chance
function PlayerManager:skill_dodge_chance(...)
	local ADD_NUM = Get_Current_ArmorSkinsBoosts("dodge")
	return skill_dodge_chance(self, ...) + ADD_NUM
end

local movement_speed_multiplier = PlayerManager.movement_speed_multiplier
function PlayerManager:movement_speed_multiplier(...)
	local ADD_NUM = Get_Current_ArmorSkinsBoosts("movement")
	return movement_speed_multiplier(self, ...) + ADD_NUM
end