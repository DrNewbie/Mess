local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

function ObjectInteractionManager:remove_contour(carry_id)
	for _, unit in pairs(self._interactive_units) do
		if unit and alive(unit) and unit:carry_data() and unit:carry_data():carry_id() == carry_id then
			unit:interaction():set_contour('standard_color', 0)
		end
	end
end
