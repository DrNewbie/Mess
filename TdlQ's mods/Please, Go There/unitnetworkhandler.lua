local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

-- just to send "secondary" to sync_call_civilian()
local pgt_original_unitnetworkhandler_longdisinteraction = UnitNetworkHandler.long_dis_interaction
function UnitNetworkHandler:long_dis_interaction(target_unit, amount, aggressor_unit, secondary)
	if secondary and amount == 0 then
		if not self._verify_gamestate(self._gamestate_filter.any_ingame) or not self._verify_character(target_unit) or not self._verify_character(aggressor_unit) then
			return
		end

		local aggressor_is_criminal = aggressor_unit:in_slot(managers.slot:get_mask('criminals'))
		if aggressor_is_criminal and target_unit:base().pgt_is_being_moved then
			if self._verify_in_server_session() then
				aggressor_unit:movement():sync_call_civilian(target_unit, secondary)
				return
			end
		end
	end

	pgt_original_unitnetworkhandler_longdisinteraction(self, target_unit, amount, aggressor_unit, secondary)
end
