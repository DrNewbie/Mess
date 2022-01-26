if not CustomDotSize then
	return
end

if not MenuCallbackHandler then
	return
end

local function AddModOptions(menu_manager)
	if menu_manager == nil then
		return
	end
	MenuCallbackHandler.CustomDotSizeSaveSettings = function(node)
		CustomDotSize:Save()
	end
	MenuCallbackHandler.CustomDotSizeSetDotPX = function(self, item)
		CustomDotSize.Settings.dot_px = item:value()
		managers.user:set_setting("accessibility_dot_size", CustomDotSize.Settings.dot_px, nil)
		if managers.hud and type(managers.hud.layout_player_hud) == "function" then
			managers.hud:layout_player_hud()
		end
	end
	MenuHelper:LoadFromJsonFile(CustomDotSize.ModOptions, CustomDotSize, CustomDotSize.Settings)
end

Hooks:Add("MenuManagerInitialize", "CustomDotSize_AddModOptions", AddModOptions)