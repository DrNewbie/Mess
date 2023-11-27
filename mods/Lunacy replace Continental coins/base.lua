local ThisModPath = ModPath

Hooks:Add("LocalizationManagerPostInit", "LCBLunacyLocLoad", function(self)
	self:add_localized_strings({
		["menu_es_coins_progress"] = "Lunacy",
		["bm_menu_btn_buy_mod"] = "Purchase with Lunacy",
		["dialog_bm_purchase_coins"] = "It will cost you $money Lunacy.",
		["menu_es_safehouse_reward_coins"] = "$amount Lunacy.",
		["menu_challenge_safehouse_daily_reward"] = "Some Lunacy to purchase safe house upgrades and weapon mods."
	})
end)

pcall(function()
	BLTAssetManager:CreateEntry( 
		"guis/dlcs/chill/textures/pd2/safehouse/continental_coins_drop", 
		Idstring("texture"), 
		ThisModPath.."continental_coins_drop.texture", 
		nil 
	)
	BLTAssetManager:CreateEntry( 
		"guis/dlcs/chill/textures/pd2/safehouse/continental_coins_symbol", 
		Idstring("texture"), 
		ThisModPath.."continental_coins_symbol.texture", 
		nil 
	)
end)