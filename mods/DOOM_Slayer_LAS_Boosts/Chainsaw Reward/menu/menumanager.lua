local mod_path = ModPath

Hooks:Add("MenuManagerInitialize", "MenuItem_AddDewmSlayaKeybinds", function(menu_manager)
	MenuCallbackHandler.dewmslaya_b_cr_keybind_1 = function(self)
	end
	MenuHelper:LoadFromJsonFile(mod_path .. "Chainsaw Reward/menu/menu.txt")
end)