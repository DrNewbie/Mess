_G.OVK_Keepers = _G.OVK_Keepers or {}

if Network:is_client() then
	return
end

if not OVK_Keepers then
	return
end

if OVK_Keepers.settings.no_too_far_so_move ~= 1 then
	return
end

function GroupAIStateBase:upd_team_AI_distance()
	if self:team_ai_enabled() then
		for _, ai in pairs(self:all_AI_criminals()) do
			local ai_pos = ai.unit:movement()._m_pos
			local closest_unit
			local closest_distance = tweak_data.team_ai.stop_action.teleport_distance * tweak_data.team_ai.stop_action.teleport_distance
			for _, player in pairs(self:all_player_criminals()) do
				local distance = mvector3.distance_sq(ai_pos, player.pos)
				if closest_distance > distance then
					closest_unit = player.unit
					closest_distance = distance
				end
			end
			if closest_unit then
				if OVK_Keepers.settings.no_too_far_so_move == 0 then
					if ai.unit:movement() and ai.unit:movement()._should_stay and closest_distance > tweak_data.team_ai.stop_action.distance * tweak_data.team_ai.stop_action.distance then
						ai.unit:movement():set_should_stay(false)
						print("[GroupAIStateBase:update] team ai is too far away, started moving again")
					end
				end
				if closest_distance > tweak_data.team_ai.stop_action.teleport_distance * tweak_data.team_ai.stop_action.teleport_distance then
					ai.unit:movement():set_position(unit:position())
					print("[GroupAIStateBase:update] team ai is too far away, teleported to player")
				end
			end
		end
	end
end