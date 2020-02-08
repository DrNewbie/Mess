local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

function RaycastWeaponBase:ammo_info()
	local abase = self:ammo_base()
	return abase:get_ammo_max_per_clip(), abase:get_ammo_remaining_in_clip(), abase:get_ammo_total(), abase:get_ammo_max(), self:gadget_overrides_weapon_functions()
end

DelayedCalls:Add('DelayedModNMA_setammoamount', 0, function()
	if HUDManager then
		local nma_original_hudmanager_setammoamount = HUDManager.set_ammo_amount
		function HUDManager:set_ammo_amount(selection_index, max_clip, current_clip, current_left, max, gadget_override)
			selection_index = selection_index == 2 and gadget_override and 3 or selection_index
			nma_original_hudmanager_setammoamount(self, selection_index, max_clip, current_clip, current_left, max, gadget_override)
		end
	end
end)
