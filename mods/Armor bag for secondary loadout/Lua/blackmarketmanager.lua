_G.ArmorBag4S = _G.ArmorBag4S or {}
ArmorBag4S.Record_Times = ArmorBag4S.Record_Times or 0

function BlackMarketManager:get_equip_weapon(category, slot)
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
	if managers.hud then
		managers.hud:recreate_weapon_firemode(HUDManager.PLAYER_PANEL)
	end	
	return Ans
end

function BlackMarketManager:set_forced_throwable(grenade)
	self._forced_throwable = tostring(grenade)
end

local ABS_BM_equipped_grenade = BlackMarketManager.equipped_grenade
function BlackMarketManager:equipped_grenade()
	if self._forced_throwable and type(self._forced_throwable) == "string" then
		local grenade = Global.blackmarket_manager.grenades[self._forced_throwable]
		if grenade and grenade.amount and grenade.unlocked then
			return self._forced_throwable, math.max(grenade.amount - ArmorBag4S.Record_Times, 0)
		end
	end
	return ABS_BM_equipped_grenade(self)
end

function BlackMarketManager:set_forced_melee(melee)
	self._forced_melee = tostring(melee)
end

local ABS_BM_equipped_melee_weapon = BlackMarketManager.equipped_melee_weapon
function BlackMarketManager:equipped_melee_weapon()
	if self._forced_melee and type(self._forced_melee) == "string" then
		local melee_weapon = Global.blackmarket_manager.melee_weapons[self._forced_melee]
		if melee_weapon and melee_weapon.unlocked then
			return self._forced_melee
		end
	end
	return ABS_BM_equipped_melee_weapon(self)
end