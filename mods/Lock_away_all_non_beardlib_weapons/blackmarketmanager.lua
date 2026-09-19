local Locked_Bool = {true, true}

local function BlackMarketManager_UnlockCustomWeapon()
	for weapon_id, weapon_data in pairs(Global.blackmarket_manager.weapons) do
		if weapon_data.unlocked then
			local _wd = tweak_data.weapon[weapon_id] or nil
			if _wd and _wd.global_value == 'nonbeardlib' then
				Global.blackmarket_manager.weapons[weapon_id].unlocked = false
			elseif _wd and _wd.global_value ~= 'nonbeardlib' and managers.dlc:is_dlc_unlocked(_wd.global_value) then
				Global.blackmarket_manager.weapons[weapon_id].unlocked = true
			end
		end
	end
end

Hooks:PostHook(BlackMarketManager, "_load_done", "BlackMarketManager_load_done_UnlockCustomWeapon", function(bb, ...)
	if Locked_Bool[1] then
		Locked_Bool[1] = nil
		BlackMarketManager_UnlockCustomWeapon()
	end
end )

Hooks:PostHook(BlackMarketManager, "_setup", "BlackMarketManager_UnlockCustomWeapon", function(self, ...)
	if Locked_Bool[2] then
		Locked_Bool[2] = nil
		BlackMarketManager_UnlockCustomWeapon()
	end
end)