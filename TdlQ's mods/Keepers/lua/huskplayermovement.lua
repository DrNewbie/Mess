local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local kpr_original_huskplayermovement_registerreviveso = HuskPlayerMovement._register_revive_SO
function HuskPlayerMovement:_register_revive_SO()
	kpr_original_huskplayermovement_registerreviveso(self)

	local so = managers.groupai:state()._special_objectives[self._revive_SO_id]
	so.data.objective.action_start_clbk = callback(self, self, 'on_revive_SO_started')
	so.unit_id = self._unit:id()
end

function HuskPlayerMovement:on_revive_SO_started(rescuer)
	local bot_name = alive(rescuer) and managers.criminals:character_name_by_unit(rescuer)
	if not bot_name then
		return
	end

	local interaction_name = self._state == 'arrested' and 'free' or 'revive'
	local timer = tweak_data.interaction[interaction_name].timer
	local str = 'kpr;' .. bot_name .. ';' .. interaction_name
	managers.hud:kpr_teammate_progress(str, true, timer, false)

	local session = managers.network:session()
	for peer_id, peer in pairs(session:peers()) do
		if peer_id ~= 1 and Keepers.clients[peer_id] then
			session:send_to_peer_synched(peer, 'sync_teammate_progress', 1, true, str, timer, false)
		end
	end
end

function HuskPlayerMovement:kpr_finalize_revive(rescuer, success)
	local bot_name = alive(rescuer) and managers.criminals:character_name_by_unit(rescuer)
	if not bot_name then
		return
	end

	local interaction_name = self._state == 'arrested' and 'free' or 'revive'
	local str = 'kpr;' .. bot_name .. ';' .. interaction_name
	managers.hud:kpr_teammate_progress(str, false, 1, success)

	local session = managers.network:session()
	for peer_id, peer in pairs(session:peers()) do
		if peer_id ~= 1 and Keepers.clients[peer_id] then
			session:send_to_peer_synched(peer, 'sync_teammate_progress', 1, false, str, 1, success)
		end
	end
end

local kpr_original_huskplayermovement_onrevivesocompleted = HuskPlayerMovement.on_revive_SO_completed
function HuskPlayerMovement:on_revive_SO_completed(rescuer)
	self:kpr_finalize_revive(rescuer, true)
	kpr_original_huskplayermovement_onrevivesocompleted(self, rescuer)
end

local kpr_original_huskplayermovement_onrevivesofailed = HuskPlayerMovement.on_revive_SO_failed
function HuskPlayerMovement:on_revive_SO_failed(rescuer)
	self:kpr_finalize_revive(rescuer, false)
	kpr_original_huskplayermovement_onrevivesofailed(self, rescuer)
end
