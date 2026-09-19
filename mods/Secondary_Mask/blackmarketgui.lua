Hooks:Add("LocalizationManagerPostInit", "2Mask_BlackMarketGui_Loc", function()
	LocalizationManager:add_localized_strings({
		["bm_menu_btn_equip_mask_2"] = "Equip Secondary Mask",
		["bm_menu_btn_unequip_mask_2"] = "Clean Secondary Mask"
	})
end)

Hooks:PostHook(BlackMarketGui, "_setup", "2Mask_BlackMarketGui_Init", function(self)
	local check_this_mask_data = function(data)
		if not Global.blackmarket_manager then
			return nil
		end	
		if type(data) ~= "table" and type(data.slot) ~= "number" then
			return nil
		end		
		local slot = data.slot		
		if not Global.blackmarket_manager.crafted_items.masks then
			return nil
		end
		if not Global.blackmarket_manager.crafted_items.masks[slot] then
			slot = 1
		end		
		local this_mask_data = Global.blackmarket_manager.crafted_items.masks[slot]		
		if type(this_mask_data) ~= "table" or not this_mask_data.mask_id then
			return nil
		end
		return this_mask_data
	end
	self.equip_mask_2_callback = function(self, data)
		local this_mask_data = check_this_mask_data(data)
		if this_mask_data and managers.menu_scene then
			managers.menu_scene:set_character_mask_2_by_id(this_mask_data.mask_id, this_mask_data.blueprint)
		end
		QuickMenu:new("[ Secondary Mask ]", "Equip!!", {}):Show()
	end
	self.unequip_mask_2_callback = function(self, data)
		managers.menu_scene:clean_character_mask_2()
		QuickMenu:new("[ Secondary Mask ]", "Clean!!", {}):Show()
	end
	self._btns["m_equip_2"] = BlackMarketGuiButtonItem:new(self._buttons, {
		prio = 1,
		btn = "BTN_A",
		pc_btn = nil,
		name = "bm_menu_btn_equip_mask_2",
		callback = callback(self, self, "equip_mask_2_callback")
	}, 10)
	self._btns["m_unequip_2"] = BlackMarketGuiButtonItem:new(self._buttons, {
		prio = 1,
		btn = "BTN_A",
		pc_btn = nil,
		name = "bm_menu_btn_unequip_mask_2",
		callback = callback(self, self, "unequip_mask_2_callback")
	}, 10)
end)

Hooks:PostHook(BlackMarketGui, "populate_masks_new", "2Mask_BlackMarketGui_Set", function(self, data)
	for k, v in pairs(data) do
		if data[k] and type(v) == "table" and v["unlocked"] then
			if tostring(json.encode({v = v})):find("m_equip") then
				table.insert(data[k], "m_equip_2")
				table.insert(data[k], "m_unequip_2")
			end
		end
	end
end)