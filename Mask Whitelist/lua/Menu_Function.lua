_G.MaskWhitelistF = _G.MaskWhitelistF or {}
MaskWhitelistF.ModPath = ModPath
MaskWhitelistF.SaveFile = MaskWhitelistF.SaveFile or SavePath .. "MaskWhitelistF.txt"
MaskWhitelistF.ModOptions = MaskWhitelistF.ModPath .. "menus/modoptions.txt"
MaskWhitelistF.settings = MaskWhitelistF.settings or {}
MaskWhitelistF.options_menu = "MaskWhitelistF_menu"
MaskWhitelistF.Whitelist = {}

Hooks:Add("LocalizationManagerPostInit", "MaskWhitelistF_loc", function(loc)
	LocalizationManager:add_localized_strings({
		["maskwhitelist_menu_title"] = "Mask Whitelist",
		["maskwhitelist_menu_desc"] = "On = Allow , OFF = Block",
		["maskwhitelist_menu_setall2on_title"] = "1. Allow ALL",
		["maskwhitelist_menu_setall2off_title"] = "2. Block ALL",
	})
end)

function MaskWhitelistF:Check(name, data)
	if name and data and data.mask_id then
		local _key = data.mask_id or ""
		local _masks = tweak_data.blackmarket.masks or {}
		if _masks then
			local _defalut_mask_id = _masks.character_locked[name] or ""
			if _defalut_mask_id and _defalut_mask_id ~= "" then
				local _defalut_mask_obj = _masks[_defalut_mask_id].unit or ""
				if _defalut_mask_obj and _defalut_mask_obj ~= "" then
					if _key ~= "" and _key ~= _defalut_mask_id and MaskWhitelistF.Whitelist[_key] == 0 then
						data.mask_obj = _defalut_mask_obj
						data.mask_id = _defalut_mask_id
					end
				end
			end
		end
	end
	return data
end

function MaskWhitelistF:Reset(onoff)
	local _masks = tweak_data.blackmarket.masks or {}
	for k, v in pairs(_masks) do
		if k ~= "character_locked" and v.name_id then
			self.Whitelist[k] = onoff and onoff or 1
		end
	end
	self:Save()
end

function MaskWhitelistF:Load()
	local _file = io.open(self.SaveFile, "r")
	if _file then
		for key, value in pairs(json.decode(_file:read("*all"))) do
			self.Whitelist[key] = value
		end
		_file:close()
	else
		self:Reset(1)
	end
end

function MaskWhitelistF:Save()
	local _file = io.open(self.SaveFile, "w+")
	if _file then
		_file:write(json.encode(self.Whitelist))
		_file:close()
	end
end

MaskWhitelistF:Load()

Hooks:Add("MenuManagerSetupCustomMenus", "MaskWhitelistFOptions", function( menu_manager, nodes )
	MenuHelper:NewMenu( MaskWhitelistF.options_menu )
end)

Hooks:Add("MenuManagerPopulateCustomMenus", "MaskWhitelistFOptions", function( menu_manager, nodes )
	local _masks = tweak_data.blackmarket.masks or {}
	local _bool = true
	for k, v in pairs(_masks) do
		if k ~= "character_locked" and v.name_id then
			local _callback_name = "maskwhitelist_toggle_" .. k
			MenuCallbackHandler[_callback_name] = function(self, item)
				if tostring(item:value()) == "on" then
					MaskWhitelistF.Whitelist[k] = 1
				else
					MaskWhitelistF.Whitelist[k] = 0
				end
				MaskWhitelistF:Save()
			end
			_bool = MaskWhitelistF.Whitelist[k] == 1 and true or false
			MenuHelper:AddToggle({
				id = _callback_name,
				title = v.name_id,
				callback = _callback_name,
				value = _bool,
				menu_id = MaskWhitelistF.options_menu,
			})
		end
	end
	MenuCallbackHandler.maskwhitelist_menu_setall2on_callback = function(self, item)
		MaskWhitelistF:Reset(1)
		local _dialog_data = {
			title = "Mask Whitelist",
			text = "Allow all of masks",
			button_list = {{ text = "[OK]", is_cancel_button = true }},
			id = tostring(math.random(0,0xFFFFFFFF))
		}
		managers.system_menu:show(_dialog_data)
	end
	MenuCallbackHandler.maskwhitelist_menu_setall2off_callback = function(self, item)
		MaskWhitelistF:Reset(0)
		local _dialog_data = {
			title = "Mask Whitelist",
			text = "Block all of masks",
			button_list = {{ text = "[OK]", is_cancel_button = true }},
			id = tostring(math.random(0,0xFFFFFFFF))
		}
		managers.system_menu:show(_dialog_data)
	end
	MenuHelper:AddButton({
		id = "maskwhitelist_menu_setall2on_callback",
		title = "maskwhitelist_menu_setall2on_title",
		callback = "maskwhitelist_menu_setall2on_callback",
		menu_id = MaskWhitelistF.options_menu,
	})
	MenuHelper:AddButton({
		id = "maskwhitelist_menu_setall2off_callback",
		title = "maskwhitelist_menu_setall2off_title",
		callback = "maskwhitelist_menu_setall2off_callback",
		menu_id = MaskWhitelistF.options_menu,
	})
end)

Hooks:Add("MenuManagerBuildCustomMenus", "MaskWhitelistFOptions", function(menu_manager, nodes)
	nodes[MaskWhitelistF.options_menu] = MenuHelper:BuildMenu( MaskWhitelistF.options_menu )
	MenuHelper:AddMenuItem( MenuHelper.menus.lua_mod_options_menu, MaskWhitelistF.options_menu, "maskwhitelist_menu_title", "maskwhitelist_menu_desc")
end)