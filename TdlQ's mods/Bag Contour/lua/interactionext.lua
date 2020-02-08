local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local bc_original_baseinteractionext_setcontour = BaseInteractionExt.set_contour
function BaseInteractionExt:set_contour(color, opacity)
	if not tweak_data.contour.interactable.money then
		BagContour:SetContourColors()
	end

	if color ~= 'selected_color' and alive(self._unit) and self._unit:carry_data() then
		local carry_id = self._unit:carry_data():carry_id()
		color = tweak_data.contour.interactable[carry_id] and carry_id or color
		if carry_id == 'person' and BagContour:CanHideBodyBagContour() then
			opacity = 0
		end
	end

	bc_original_baseinteractionext_setcontour(self, color, opacity)
end
