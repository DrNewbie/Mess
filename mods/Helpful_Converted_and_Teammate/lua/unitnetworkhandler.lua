if Network:is_client() then
	return
end

_G.HelpfulConverted = _G.HelpfulConverted or {}
Hooks:PreHook(UnitNetworkHandler, "sync_contour_state", "HelpfulConverted_Client_Down", function(self, unit, u_id, type, ...)
	if tostring(type) == "teammate_downed" then
		DelayedCalls:Add('DelayedMod_Help_'..tostring(unit:key()), 3, function()
			HelpfulConverted:Do_Help(unit)
		end)
	end
end)