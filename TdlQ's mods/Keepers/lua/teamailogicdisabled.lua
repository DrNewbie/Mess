local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local kpr_original_teamailogicdisabled_registerreviveso = TeamAILogicDisabled._register_revive_SO
function TeamAILogicDisabled._register_revive_SO(data, my_data, rescue_type)
	kpr_original_teamailogicdisabled_registerreviveso(data, my_data, rescue_type)

	data.kpr_rescue_type = rescue_type
	local so = managers.groupai:state()._special_objectives[my_data.SO_id]
	so.data.objective.complete_clbk = callback(TeamAILogicDisabled, TeamAILogicDisabled, 'on_revive_SO_completed', data)
	so.data.objective.action_start_clbk = callback(TeamAILogicDisabled, TeamAILogicDisabled, 'on_revive_SO_started', data)
	so.unit_id = data.unit:id()
end

function TeamAILogicDisabled:on_revive_SO_started(data)
	local rescuer = data.internal_data.rescuer
	local bot_name = alive(rescuer) and managers.criminals:character_name_by_unit(rescuer)
	if not bot_name then
		return
	end

	local interaction_name = data.kpr_rescue_type == 'untie' and 'free' or data.kpr_rescue_type
	local timer = tweak_data.interaction[interaction_name].timer
	local str = 'kpr;' .. bot_name .. ';' .. interaction_name
	if managers.hud then
		managers.hud:kpr_teammate_progress(str, true, timer, false)
	end

	local session = managers.network:session()
	for peer_id, peer in pairs(session:peers()) do
		if peer_id ~= 1 and Keepers.clients[peer_id] then
			session:send_to_peer_synched(peer, 'sync_teammate_progress', 1, true, str, timer, false)
		end
	end
end

function TeamAILogicDisabled.kpr_finalize_revive(data, rescuer, success)
	local bot_name = alive(rescuer) and managers.criminals:character_name_by_unit(rescuer)
	if not bot_name then
		return
	end

	local interaction_name = data.kpr_rescue_type == 'untie' and 'free' or data.kpr_rescue_type or 'revive'
	local unit_data = rescuer:unit_data()
	local str = 'kpr;' .. bot_name .. ';' .. interaction_name
	if managers.hud then
		managers.hud:kpr_teammate_progress(str, false, 1, success)
	end

	local session = managers.network:session()
	for peer_id, peer in pairs(session:peers()) do
		if peer_id ~= 1 and Keepers.clients[peer_id] then
			session:send_to_peer_synched(peer, 'sync_teammate_progress', 1, false, str, 1, success)
		end
	end
end

function TeamAILogicDisabled:on_revive_SO_completed(data, rescuer)
	self.kpr_finalize_revive(data, rescuer, true)
end

local kpr_original_teamailogicdisabled_onrevivesofailed = TeamAILogicDisabled.on_revive_SO_failed
function TeamAILogicDisabled.on_revive_SO_failed(self, data, rescuer)
	kpr_original_teamailogicdisabled_onrevivesofailed(self, data, rescuer)
	self.kpr_finalize_revive(data, rescuer, false)
end
