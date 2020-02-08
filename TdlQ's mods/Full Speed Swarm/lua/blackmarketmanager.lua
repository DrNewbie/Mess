local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local ceg
local fs_original_blackmarketmanager_equippedgrenade = BlackMarketManager.equipped_grenade
function BlackMarketManager:cached_equipped_grenade()
	if not ceg then
		ceg = {fs_original_blackmarketmanager_equippedgrenade(self)}
	end
	return unpack(ceg)
end

local cached_equipped_armor
local has_armor_kit
function BlackMarketManager:equipped_armor(chk_armor_kit, chk_player_state)
	if chk_player_state and managers.player:current_state() == 'civilian' then
		return self._defaults.armor
	end

	local current_state_name = game_state_machine and game_state_machine:current_state_name()
	if chk_armor_kit and has_armor_kit ~= false then
		has_armor_kit = managers.player:equipment_slot('armor_kit')
		if has_armor_kit and (managers.player:get_equipment_amount('armor_kit') > 0 or current_state_name == 'ingame_waiting_for_players') then
			return self._defaults.armor
		end
	end

	if cached_equipped_armor then
		return cached_equipped_armor, true
	end
	local cacheable = current_state_name and current_state_name ~= 'ingame_waiting_for_players' and current_state_name:sub(1, 7) == 'ingame_'

	local armor
	for armor_id, data in pairs(tweak_data.blackmarket.armors) do
		armor = Global.blackmarket_manager.armors[armor_id]
		if armor.equipped and armor.unlocked and armor.owned then
			local forced_armor = self:forced_armor()
			if forced_armor then
				cached_equipped_armor = cacheable and forced_armor
				return forced_armor
			end
			cached_equipped_armor = cacheable and armor_id
			return armor_id
		end
	end
	cached_equipped_armor = cacheable and self._defaults.armor
	return self._defaults.armor
end
