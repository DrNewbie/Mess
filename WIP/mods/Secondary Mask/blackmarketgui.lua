Hooks:Add("LocalizationManagerPostInit", "2Mask_BlackMarketGui_Loc", function()
	LocalizationManager:add_localized_strings({
		["bm_menu_btn_equip_mask_2"] = "Equip Secondary Mask",
		["bm_menu_btn_unequip_mask_2"] = "Unequip Secondary Mask"
	})
end)

Hooks:PostHook(BlackMarketGui, "_setup", "2Mask_BlackMarketGui_Init", function(self)
	self.equip_mask_2_callback = function(self, data)
		if not Global.blackmarket_manager then
			return
		end
	
		if type(data) ~= "table" and type(data.slot) ~= "number" then
			return
		end
		
		local slot = data.slot
		
		if not Global.blackmarket_manager.crafted_items.masks then
			return
		end

		if not Global.blackmarket_manager.crafted_items.masks[slot] then
			slot = 1
		end
		
		local new_mask_data = Global.blackmarket_manager.crafted_items.masks[slot]
		
		if not new_mask_data then
			return
		end
		
		if managers.menu_scene then
			managers.menu_scene:set_character_mask_2_by_id(new_mask_data.mask_id, new_mask_data.blueprint)
		end
		
		QuickMenu:new("[ Secondary Mask ]", "Equip!!", {}):Show()
	end
	self.unequip_mask_2_callback = function(self, data)
		--unequip_mask_2_callback
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
				--table.insert(data[k], "m_unequip_2")
			end
		end
	end
end)