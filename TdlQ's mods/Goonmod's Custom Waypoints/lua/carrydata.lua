local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local gcw_original_carrydata_destroy = CarryData.destroy
function CarryData:destroy(...)
	if managers.hud then
		managers.hud:gcw_remove_attached_waypoints(self._unit)
	end
	return gcw_original_carrydata_destroy(self, ...)
end
