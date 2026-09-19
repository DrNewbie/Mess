local old_func1 = "F_"..Idstring("_update_point_of_no_return:Escape No Return"):key()

GroupAIStateBase[old_func1] = GroupAIStateBase[old_func1] or GroupAIStateBase._update_point_of_no_return

function GroupAIStateBase:_update_point_of_no_return(t, dt, ...)
	local get_mission_script_element = function(id)
		for name, script in pairs(managers.mission:scripts()) do
			if script:element(id) then
				return script:element(id)
			end
		end
	end
	self._point_of_no_return_timer = self._point_of_no_return_timer - dt
	if not self._point_of_no_return_id or not get_mission_script_element(self._point_of_no_return_id) then
		if self._point_of_no_return_timer <= 0 then
			managers.network:session():send_to_peers("mission_ended", false, 0)
			game_state_machine:change_state_by_name("gameoverscreen")
		else
			managers.hud:feed_point_of_no_return_timer(self._point_of_no_return_timer)
		end
	else
		self[old_func1](self, t, dt, ...)
	end
end