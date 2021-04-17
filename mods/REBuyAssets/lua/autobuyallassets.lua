_G.REBuyAssets = _G.REBuyAssets or {}

Hooks:PostHook(MissionBriefingGui, "create_asset_tab", "REBuyAssets_DoAssets", function(...)
	REBuyAssets.settings = REBuyAssets.settings or {}
	REBuyAssets.settings["AutoBuyAllAssets"] = REBuyAssets.settings["AutoBuyAllAssets"] or 0
	if REBuyAssets.settings["AutoBuyAllAssets"] == 1 then
		local asset_ids = managers.assets:get_all_asset_ids(true) or {}
		for _, asset_id in pairs(asset_ids) do
			local asset = managers.assets:_get_asset_by_id(asset_id)
			if asset.can_unlock then
				managers.assets:unlock_asset(asset_id)
			end
		end
	end
end )