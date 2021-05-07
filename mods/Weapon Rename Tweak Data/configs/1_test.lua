_G.GGWEPNENAME = _G.GGWEPNENAME or {}

GGWEPNENAME:Add(nil, function(data, factory_id, blueprint, W_data)
	if factory_id == "wpn_fps_ass_m16" then
		if table.contains(blueprint, "wpn_fps_m16_fg_vietnam") then
			return "AMR-16A1"
		end
	end
	return data.name_localized
end)