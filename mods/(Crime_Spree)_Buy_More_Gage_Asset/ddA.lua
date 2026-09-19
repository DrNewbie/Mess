function MenuManager:show_confirm_mission_gage_asset_buy(params)
	managers.crime_spree:new_asset_tweak_data_cost(params.asset_id)
	local asset_tweak_data = tweak_data.crime_spree.assets[params.asset_id]
	local dialog_data = {}
	dialog_data.title = managers.localization:text("dialog_assets_buy_title")
	dialog_data.text = managers.localization:text("dialog_mission_asset_buy", {
		asset_desc = managers.localization:text(asset_tweak_data.unlock_desc_id or "menu_asset_unknown_unlock_desc", asset_tweak_data.data),
		cost = managers.localization:text("bm_cs_continental_coin_cost", {
			cost = managers.experience:cash_string(asset_tweak_data.cost, "")
		})
	})
	dialog_data.focus_button = 2
	local yes_button = {}
	yes_button.text = managers.localization:text("dialog_yes")
	yes_button.callback_func = params.yes_func
	local no_button = {}
	no_button.text = managers.localization:text("dialog_no")
	no_button.callback_func = params.no_func
	no_button.cancel_button = true
	dialog_data.button_list = {yes_button, no_button}
	managers.system_menu:show(dialog_data)
end

if Announcer then
	Announcer:AddHostMod('Buy More Gage Asset, (Allow me buy more Gage Asset in Crime Spree)')
end