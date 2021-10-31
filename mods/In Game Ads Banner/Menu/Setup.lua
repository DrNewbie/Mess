function IGAdsB:OptChanged()
	if IGAdsB.AdsGui then
		local them = IGAdsB.AdsGui
		local __offset_pos_x = IGAdsB.Options:GetValue("__offset_pos_x") or 83
		local __offset_pos_y = IGAdsB.Options:GetValue("__offset_pos_y") or 83
		local __scale = IGAdsB.Options:GetValue("__scale") or 100
		__offset_pos_x = __offset_pos_x / 100
		__offset_pos_y = __offset_pos_y / 100
		__scale = __scale / 100
		
		them._content_panel:set_center_x(them._panel:width()*__offset_pos_x)
		them._content_panel:set_center_y(them._panel:height()*__offset_pos_y)

		--[[
		local IMAGE_H = 123 * __scale
		local IMAGE_W = 416 * __scale
		local SPOT_W = 32 * __scale
		local SPOT_H = 8 * __scale
		local BAR_W = 32 * __scale
		local BAR_H = 6 * __scale
		local BAR_X = (SPOT_W - BAR_W) / 2
		local BAR_Y = 0
		them._internal_content_panel:set_width(IMAGE_W)
		them._internal_content_panel:set_h(IMAGE_H)
		them._internal_image_panel:set_width(IMAGE_W)
		them._internal_image_panel:set_h(IMAGE_H)
		for _, ads in pairs(them._contents) do
			if ads then
				ads:set_size(IMAGE_W, IMAGE_H)
			end
		end
		]]
	end
end

function IGAdsB:ResetToDefault()
	IGAdsB.Options:SetValue("__offset_pos_x", 83)
	IGAdsB.Options:SetValue("__offset_pos_y", 83)
	IGAdsB.Options:SetValue("__scale", 100)
	IGAdsB:OptChanged()
end