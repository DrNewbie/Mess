local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

function UnitNetworkHandler:action_aim_state(cop, state)
	if not self._verify_gamestate(self._gamestate_filter.any_ingame) or not self._verify_character(cop) then
		return
	end

	if state then
		local shoot_action = {
			block_type = 'action',
			body_part = 3,
			type = 'shoot'
		}
		cop:movement():action_request(shoot_action)
	else
		cop:movement():sync_action_aim_end()
	end
end
