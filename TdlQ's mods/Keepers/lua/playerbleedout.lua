local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local kpr_original_playerbleedout_registerreviveso = PlayerBleedOut._register_revive_SO
function PlayerBleedOut._register_revive_SO(revive_SO_data, variant)
	kpr_original_playerbleedout_registerreviveso(revive_SO_data, variant)

	local so = managers.groupai:state()._special_objectives['Playerrevive']
	so.unit_id = revive_SO_data.unit:id()
end

local kpr_original_playerbleedout_onrescuesostarted = PlayerBleedOut.on_rescue_SO_started
function PlayerBleedOut:on_rescue_SO_started(revive_SO_data, rescuer)
	kpr_original_playerbleedout_onrescuesostarted(self, revive_SO_data, rescuer)

	local bot_name = alive(rescuer) and managers.criminals:character_name_by_unit(rescuer)
	if not bot_name then
		return
	end

	local interaction_name = revive_SO_data.variant == 'untie' and 'free' or revive_SO_data.variant
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

function PlayerBleedOut:kpr_finalize_rescue(revive_SO_data, rescuer, success)
	local bot_name = alive(rescuer) and managers.criminals:character_name_by_unit(rescuer)
	if not bot_name then
		return
	end

	local interaction_name = revive_SO_data.variant == 'untie' and 'free' or revive_SO_data.variant
	local timer = tweak_data.interaction[interaction_name].timer
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

local kpr_original_playerbleedout_onrescuesocompleted = PlayerBleedOut.on_rescue_SO_completed
function PlayerBleedOut:on_rescue_SO_completed(revive_SO_data, rescuer)
	kpr_original_playerbleedout_onrescuesocompleted(self, revive_SO_data, rescuer)
	self:kpr_finalize_rescue(revive_SO_data, rescuer, true)
end

local kpr_original_playerbleedout_onrescuesofailed = PlayerBleedOut.on_rescue_SO_failed
function PlayerBleedOut:on_rescue_SO_failed(revive_SO_data, rescuer)
	kpr_original_playerbleedout_onrescuesofailed(self, revive_SO_data, rescuer)
	self:kpr_finalize_rescue(revive_SO_data, rescuer, false)
end
