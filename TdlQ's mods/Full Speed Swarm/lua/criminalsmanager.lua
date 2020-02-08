local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local fs_original_criminalsmanager_addcharacter = CriminalsManager.add_character
function CriminalsManager:add_character(name, unit, peer_id, ...)
	managers.player:reset_cached_hostage_bonus_multiplier()
	if peer_id == managers.network:session():local_peer():id() then
		BlackMarketManager.equipped_grenade = BlackMarketManager.cached_equipped_grenade
	end
	return fs_original_criminalsmanager_addcharacter(self, name, unit, peer_id, ...)
end

local fs_original_criminalsmanager_remove = CriminalsManager._remove
function CriminalsManager:_remove(id)
	managers.player:reset_cached_hostage_bonus_multiplier()
	return fs_original_criminalsmanager_remove(self, id)
end

local fs_original_criminalsmanager_setunit = CriminalsManager.set_unit
function CriminalsManager:set_unit(name, unit, ai_loadout)
	if alive(unit) then
		fs_original_criminalsmanager_setunit(self, name, unit, ai_loadout)

		local inventory = unit:inventory()
		if inventory and inventory._ensure_weapon_visibility then
			inventory:_ensure_weapon_visibility()
		end
	end
end
