_G.REBuyAssets = _G.REBuyAssets or {}

if not REBuyAssets or Network:is_client() then
	return
end

Hooks:PostHook(PrePlanningManager, "reserve_mission_element", "REBuyAssets_reserve_mission_element", function(pree, type, id, ...)
	local current_stage = managers.job:current_level_id()
	if current_stage then
		local _idx = "id_" .. id
		REBuyAssets.settings = REBuyAssets.settings or {}
		REBuyAssets.settings[current_stage] = REBuyAssets.settings[current_stage] or {}
		REBuyAssets.settings[current_stage][_idx] = {id = id, bool = true, type = type}
	end
end )

Hooks:PostHook(PrePlanningManager, "unreserve_mission_element", "REBuyAssets_unreserve_mission_element", function(pree, id, ...)
	local current_stage = managers.job:current_level_id()
	if current_stage then
		local _idx = "id_" .. id
		REBuyAssets.settings = REBuyAssets.settings or {}
		REBuyAssets.settings[current_stage] = REBuyAssets.settings[current_stage] or {}
		REBuyAssets.settings[current_stage][_idx] = REBuyAssets.settings[current_stage][_idx] or {}
		REBuyAssets.settings[current_stage][_idx]["bool"] = false
	end
end )