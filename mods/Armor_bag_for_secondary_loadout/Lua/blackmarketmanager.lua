_G.ArmorBag4S = _G.ArmorBag4S or {}

ArmorBag4S.Record_Times = ArmorBag4S.Record_Times or 0

function BlackMarketManager:ArmorBag4S_get_equip_weapon(category, slot)
	local Ans = {}
	if not Global.blackmarket_manager.crafted_items[category] then
		return nil
	end
	for s, data in pairs(Global.blackmarket_manager.crafted_items[category]) do
		if s == slot and self:weapon_unlocked_by_crafted(category, slot) then
			Ans = data
			break
		end
	end
	return Ans
end

function BlackMarketManager:ArmorBag4S_set_forced_throwable(grenade)
	self.ArmorBag4S_forced_throwable = tostring(grenade)
end

local ABS_BM_equipped_grenade = BlackMarketManager.equipped_grenade
function BlackMarketManager:equipped_grenade()
	if self.ArmorBag4S_forced_throwable and type(self.ArmorBag4S_forced_throwable) == "string" then
		local grenade = Global.blackmarket_manager.grenades[self.ArmorBag4S_forced_throwable]
		if grenade and grenade.amount and grenade.unlocked then
			return self.ArmorBag4S_forced_throwable, math.max(grenade.amount - ArmorBag4S.Record_Times, 0)
		end
	end
	return ABS_BM_equipped_grenade(self)
end

function BlackMarketManager:ArmorBag4S_set_forced_melee(melee)
	self.ArmorBag4S_forced_melee = tostring(melee)
end

local ABS_BM_equipped_melee_weapon = BlackMarketManager.equipped_melee_weapon
function BlackMarketManager:equipped_melee_weapon()
	if self.ArmorBag4S_forced_melee and type(self.ArmorBag4S_forced_melee) == "string" then
		local melee_weapon = Global.blackmarket_manager.melee_weapons[self.ArmorBag4S_forced_melee]
		if melee_weapon and melee_weapon.unlocked then
			return self.ArmorBag4S_forced_melee
		end
	end
	return ABS_BM_equipped_melee_weapon(self)
end

function BlackMarketManager:ArmorBag4S_set_forced_armor(armor)
	self.ArmorBag4S_forced_armor = tostring(armor)
end

local ABS_BM_equipped_armor = BlackMarketManager.equipped_armor
function BlackMarketManager:equipped_armor()
	if self.ArmorBag4S_forced_armor and type(self.ArmorBag4S_forced_armor) == "string" then
		local armor = Global.blackmarket_manager.armors[self.ArmorBag4S_forced_armor]
		if armor.unlocked and armor.owned then
			return self.ArmorBag4S_forced_armor
		end
	end
	return ABS_BM_equipped_armor(self)
end