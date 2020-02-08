local fss_original_unitnetworkhandler_syncswansonghud = UnitNetworkHandler.sync_swansong_hud
function UnitNetworkHandler:sync_swansong_hud(unit, ...)
	fss_original_unitnetworkhandler_syncswansonghud(self, unit, ...)

	if alive(unit) then
		local state = unit:movement():current_state_name()
		if state == "standard" or state == "carry" or state == "tased" then
			if not unit:contour():is_flashing() then
				unit:contour():add("teammate_downed")
				unit:contour():flash("teammate_downed", 0.15)
			end
		end
	end
end

local fss_original_unitnetworkhandler_synccontourstate = UnitNetworkHandler.sync_contour_state
function UnitNetworkHandler:sync_contour_state(unit, u_id, type, state, ...)
	if alive(unit) and unit:id() ~= -1 then
		if state and ContourExt.indexed_types[type] == "teammate_downed" then
			unit:contour():remove("teammate_downed")
		end
	end

	fss_original_unitnetworkhandler_synccontourstate(self, unit, u_id, type, state, ...)
end
