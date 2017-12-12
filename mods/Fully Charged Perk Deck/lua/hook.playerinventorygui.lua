require("lib/managers/menu/WalletGuiObject")
require("lib/utils/InventoryDescription")

Hooks:PostHook(PlayerInventoryGui, "init", "CustomPerkPlyInvInit", function(self)
	self:_update_specialization_box()
end)

Hooks:PostHook(PlayerInventoryGui, "_update_specialization_box", "CustomPerkPlyInvUpdate", function(self)
	local box = self._boxes_by_name.specialization
	if box then
		local current_specialization = managers.skilltree:get_specialization_value("current_specialization")
		local specialization_data = tweak_data.skilltree.specializations[current_specialization]
		if specialization_data then
			local specialization_text = managers.localization:text(specialization_data.name_id) or " "
			local max_tier = managers.skilltree:get_specialization_value(current_specialization, "tiers", "max_tier")
			local tier_data = specialization_data[max_tier]
			if tier_data.custom and tier_data.texture then
				self:update_box(box, {
					text = specialization_text,
					image = tier_data.texture,
					image_rect = {
						tier_data.icon_xy and tier_data.icon_xy[1] or 0,
						tier_data.icon_xy and tier_data.icon_xy[2] or 0,
						tier_data.icon_xy and tier_data.icon_xy[3] or 64,
						tier_data.icon_xy and tier_data.icon_xy[4] or 64
					}
				}, true)
			end
		end
	end
end)