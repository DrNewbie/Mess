if not Network:is_client() then
	return
end

local _f_GroupAIStateBase__update_point_of_no_return = GroupAIStateBase._update_point_of_no_return

function GroupAIStateBase:_update_point_of_no_return(t, dt)
	local get_mission_script_element = function(id)
		for name, script in pairs(managers.mission:scripts()) do
			if script:element(id) then
				return script:element(id)
			end
		end
	end
	self._point_of_no_return_timer = self._point_of_no_return_timer - dt
	if not self._point_of_no_return_id or not get_mission_script_element(self._point_of_no_return_id) then
		if isPlaying() then
			managers.hud:feed_point_of_no_return_timer(self._point_of_no_return_timer)
		end
	else
		_f_GroupAIStateBase__update_point_of_no_return(self, t, dt)
	end
end

function isPlaying()
	if not BaseNetworkHandler then return false end
	return BaseNetworkHandler._gamestate_filter.any_ingame_playing[ game_state_machine:last_queued_state_name() ]
end