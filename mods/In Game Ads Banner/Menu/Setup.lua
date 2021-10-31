function IGAdsB:OptChanged()
	if IGAdsB.AdsGui then
		local PANEL_PADDING = 10
		local __offset_pos_x = IGAdsB.Options:GetValue("__offset_pos_x") or 100
		local __offset_pos_y = IGAdsB.Options:GetValue("__offset_pos_y") or 0
		local them = IGAdsB.AdsGui
		them._content_panel:set_right(them._panel:width()*__offset_pos_x /100)
		them._content_panel:set_bottom((them._panel:height()-PANEL_PADDING*2)*__offset_pos_y/100)
	end
end

function IGAdsB:ResetToDefault()
	IGAdsB.Options:SetValue("__offset_pos_x", 100)
	IGAdsB.Options:SetValue("__offset_pos_y", 0)	
	IGAdsB:OptChanged()
end