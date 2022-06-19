local ThisModPath = _G.EEArmorBuffMain.ThisModPath
local ThisModSavePath = SavePath.."EEnchantingArmor.txt"
local Loc01 = _G.EEArmorBuffMain.__Name("load_localization_file")
local Hook1 = _G.EEArmorBuffMain.__Name("BMGui:_setup")
local Hook2 = _G.EEArmorBuffMain.__Name("BMGui:populate_armors")
local Hook3 = _G.EEArmorBuffMain.__Name("BMGui:update_info_text")
local Func1 = _G.EEArmorBuffMain.__Name("Func1")
local Func2 = _G.EEArmorBuffMain.__Name("Func2")

Hooks:PostHook(BlackMarketGui, "_setup", Hook1, function(self)
	self[Func2] = self[Func2] or function(self)
		if managers.player:__EE_Armor_Conis() > managers.custom_safehouse:coins() then
			managers.system_menu:show({
				title = "["..managers.localization:text("bm_menu_enchant_armor_name_id").."]",
				text = managers.localization:text("bm_menu_enchant_armor_no_coins"),
				button_list = {
					{text = "[Cancel]", is_cancel_button = true}
				},
				id = tostring(math.random(0,0xFFFFFFFF))
			})
			return
		else
			managers.custom_safehouse:deduct_coins(managers.player:__EE_Armor_Conis())
			self:__roll_eenchanting_armor_function()
		end
		return
	end
	self[Func1] = self[Func1] or function(self, data)
		managers.system_menu:show({
			title = "["..managers.localization:text("bm_menu_enchant_armor_name_id").."]",
			text = managers.localization:text("bm_menu_enchant_armor_desc_id"),
			button_list = {
				{text = "No", is_cancel_button = true},
				{text = "Yes (Cost: ".. managers.experience:cash_string(managers.player:__EE_Armor_Conis(), "") .." coins)", callback_func = callback(self, self, Func2)},
				{text = "[Cancel]", is_cancel_button = true}
			},
			id = tostring(math.random(0,0xFFFFFFFF))
		})
		return
	end
	self._btns["a_mod_plus"] = BlackMarketGuiButtonItem:new(self._buttons, {
		prio = 1,
		btn = "BTN_A",
		pc_btn = nil,
		name = "bm_menu_btn_enchant_armor_name_id",
		callback = callback(self, self, Func1)
	}, 10)
	if self._armor_stats_panel and self._stats_panel then
		local small_font = tweak_data.menu.pd2_small_font
		local small_font_size = tweak_data.menu.pd2_small_font_size
		
		local armor_stats_panel = self._armor_stats_panel
		local addon_armor_desc = self._stats_panel:text({
			name = "addon_armor_desc",
			text = " ",
			layer = 1,
			font_size = small_font_size,
			font = small_font,
			color = tweak_data.screen_colors.text,
			x = armor_stats_panel:x() + 2,
			y = armor_stats_panel:y() + (#self._armor_stats_shown + 1) * 20,
			w = armor_stats_panel:w(),
			h = small_font_size * 5,
			visible = false
		})
		self:__set_eenchanting_armor_date_to_text(true)
	end
end)

Hooks:PostHook(BlackMarketGui, "populate_armors", Hook2, function(self, data)
	for __k, __v in pairs(data) do
		if data[__k] and type(__v) == "table" and __v["unlocked"] and __v["category"] == "armors" and managers.player:__EE_Armor_Allow_Armor_List()[__v["name"]] then
			table.insert(data[__k], "a_mod_plus")
		end
	end
end)

Hooks:PreHook(BlackMarketGui, "update_info_text", Hook3, function(self)
	local slot_data = self._slot_data
	local tab_data = self._tabs[self._selected]._data
	local prev_data = tab_data.prev_node_data
	local ids_category = Idstring(slot_data.category)
	local identifier = tab_data.identifier
	if identifier == self.identifiers.armor and type(slot_data) == "table" and slot_data["unlocked"] and slot_data["category"] == "armors" and managers.player:__EE_Armor_Allow_Armor_List()[slot_data["name"]] then
		self:__set_eenchanting_armor_date_to_text(true)
	else
		self:__set_eenchanting_armor_date_to_text(false)		
	end
end)

Hooks:Add("LocalizationManagerPostInit", Loc01, function(loc)
	loc:load_localization_file(ThisModPath.."/loc/loc.json")
end)