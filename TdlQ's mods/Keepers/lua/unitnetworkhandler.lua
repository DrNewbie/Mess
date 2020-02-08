local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local kpr_original_unitnetworkhandler_markminion = UnitNetworkHandler.mark_minion
function UnitNetworkHandler:mark_minion(unit, minion_owner_peer_id, convert_enemies_health_multiplier_level, passive_convert_enemies_health_multiplier_level, sender)
	if not self._verify_gamestate(self._gamestate_filter.any_ingame) or not self._verify_character_and_sender(unit, sender) then
		return
	end

	unit:base().kpr_minion_owner_peer_id = minion_owner_peer_id
	kpr_original_unitnetworkhandler_markminion(self, unit, minion_owner_peer_id, convert_enemies_health_multiplier_level, passive_convert_enemies_health_multiplier_level, sender)
	Keepers:SetJokerLabel(unit)
end

local kpr_original_unitnetworkhandler_hostagetrade = UnitNetworkHandler.hostage_trade
function UnitNetworkHandler:hostage_trade(unit, enable, trade_success)
	Keepers:DestroyLabel(unit)
	kpr_original_unitnetworkhandler_hostagetrade(self, unit, enable, trade_success)
end

if Network:is_client() then
	local kpr_original_unitnetworkhandler_syncteammateprogress = UnitNetworkHandler.sync_teammate_progress
	function UnitNetworkHandler:sync_teammate_progress(type_index, enabled, tweak_data_id, timer, success, sender)
		local sender_peer = self._verify_sender(sender)
		if not self._verify_gamestate(self._gamestate_filter.any_ingame) or not sender_peer then
			return
		end
		local peer_id = sender_peer:id()

		if peer_id == 1 and tweak_data_id:find('kpr;') == 1 then
			managers.hud:kpr_teammate_progress(tweak_data_id, enabled, timer, success)
			return
		end

		kpr_original_unitnetworkhandler_syncteammateprogress(self, type_index, enabled, tweak_data_id, timer, success, sender)
	end
end
