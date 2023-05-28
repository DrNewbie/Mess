local DeadManSysMain = _G.DeadManSysMain

if DeadManSysMain._hooks.block_in_menu then
	return
else
	DeadManSysMain._hooks.block_in_menu = true
end

Hooks:PostHook(BlackMarketGui, "populate_characters", DeadManSysMain.__Name("BMGui:populate_characters"), function(self, data, ...)
	if type(data) == "table" then
		for __i, __d in pairs(data) do
			if type(__d) == "table" and type(__d.name) == "string" and DeadManSysMain._funcs.IsThisCharacterDead(__d.name) then
				data[__i].unlocked = false
				data[__i].equipped = false
				data[__i].dlc_locked = "dmsm_menu_dead_man_block"
				data[__i].lock_texture = "dmsm/texture/dmsm_skull"
				data[__i].btn_show_funcs = {}
				table.delete(data[__i], "c_swap_slots")
				table.delete(data[__i], "can_swap_character")
				table.delete(data[__i], "c_equip_to_slot")
				table.delete(data[__i], "c_clear_slots")
			end
		end
	end
end)

Hooks:PostHook(BlackMarketGui, "update_info_text", DeadManSysMain.__Name("BMGui:update_info_text"), function(self, ...)
	local slot_data = self._slot_data
	local tab_data = self._tabs[self._selected]._data
	local identifier = tostring(tab_data.identifier)
	local category = tostring(self._tabs[self._selected]._data.category)
	if identifier == self.identifiers.character or category == "characters" then
		if type(slot_data.name) == "string" and DeadManSysMain._funcs.IsThisCharacterDead(slot_data.name) then
			local char_name = slot_data.name
			local desc_id = "dmsm_desc_dead_man_"..char_name
			local dead_desc = DeadManSysMain._funcs.GetThisCharacterDeadDesc(char_name)
			LocalizationManager:add_localized_strings({
				[desc_id] = table.concat(dead_desc, "\n")
			})
			self:set_info_text(4, managers.localization:text(desc_id))
		end
	end
end)