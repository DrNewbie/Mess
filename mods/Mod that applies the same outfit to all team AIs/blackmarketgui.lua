local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local __Name = function(__id)
	return "AOTAC_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end

Hooks:PostHook(BlackMarketGui, "_setup", __Name("_setup"), function(self)
	local __btn = __Name("apply_outfit_to_all_crew")
	local __Func1 = __Name("__Func1")
	local __Func2 = __Name("__Func2")
	self[__Func2] = self[__Func2] or function(self)
		local slot_data = self._slot_data
		if type(slot_data) == "table" and slot_data["unlocked"] and slot_data["category"] == "player_styles" then
			for __i = 1, 3 do
				local __loadout = managers.blackmarket:henchman_loadout(__i)
				__loadout.player_style = slot_data["name"]
				managers.blackmarket:set_henchman_loadout(__loadout)
			end
		end
		return
	end
	self[__Func1] = self[__Func1] or function(self, data)
		managers.system_menu:show({
			title = "["..managers.localization:text("bm_menu_apply_outfit_to_all_crew_title").."]",
			text = managers.localization:text("bm_menu_apply_outfit_to_all_crew_desc"),
			button_list = {
				{text = "No", is_cancel_button = true},
				{text = "Yes", callback_func = callback(self, self, __Func2)},
				{text = "[Cancel]", is_cancel_button = true}
			},
			id = tostring(math.random(0,0xFFFFFFFF))
		})
		return
	end
	self._btns[__btn] = BlackMarketGuiButtonItem:new(self._buttons, {
		prio = 1,
		btn = "BTN_A",
		pc_btn = nil,
		name = "bm_menu_btn_apply_outfit_to_all_crew",
		callback = callback(self, self, __Func1)
	}, 10)
end)

Hooks:PostHook(BlackMarketGui, "populate_player_styles", __Name("populate_player_styles"), function(self, data)
	for __k, __v in pairs(data) do
		if data[__k] and type(__v) == "table" and __v["unlocked"] and __v["category"] == "player_styles" then
			table.insert(data[__k], __Name("apply_outfit_to_all_crew"))
		end
	end
end)

Hooks:Add("LocalizationManagerPostInit", __Name("LocalizationManagerPostInit"), function(loc)
	loc:load_localization_file(ThisModPath.."/en_loc.json")
end)