_G.REBuyAssets = _G.REBuyAssets or {}

Hooks:PostHook(AssetsItem, "chk_preplanning_textures_done", "REBuyAssets_DoPreplanning", function(...)
	REBuyAssets:Load()
	local current_stage = managers.job:current_level_id()
	local done = {}
	if current_stage then
		REBuyAssets.settings[current_stage] = REBuyAssets.settings[current_stage] or {}
		for _, _data in pairs(REBuyAssets.settings[current_stage]) do
			local _idx = "id_" .. tostring( _data.id)
			if _data.id and not done[_idx] then
				done[_idx] = true
				if _data.bool and _data.type then
					managers.preplanning:server_reserve_mission_element(_data.type, _data.id, 1)
				else
					managers.preplanning:server_unreserve_mission_element(_data.id, 1)
				end
			end
		end
	end
end )

Hooks:PostHook(MissionBriefingGui, "create_asset_tab", "REBuyAssets_DoAssets", function(...)
	REBuyAssets.settings = REBuyAssets.settings or {}
	REBuyAssets.settings["AutoBuyAllAssets"] = REBuyAssets.settings["AutoBuyAllAssets"] or 0
	if REBuyAssets.settings["AutoBuyAllAssets"] == 1 then
		local asset_ids = managers.assets:get_all_asset_ids(true) or {}
		for _, asset_id in pairs(asset_ids) do
			managers.assets:unlock_asset(asset_id)
		end
	end
end )