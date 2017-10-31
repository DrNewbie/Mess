if Network:is_client() then
	return
end

_G.SurvivorModeBase = _G.SurvivorModeBase or {}

SurvivorModeBase.Timer_Enable = false
SurvivorModeBase.Cap_Time = 180

local _f_GroupAIStateBase__update_point_of_no_return = GroupAIStateBase._update_point_of_no_return

function GroupAIStateBase:_update_point_of_no_return(t, dt)
	local get_mission_script_element = function(id)
		for name, script in pairs(managers.mission:scripts()) do
			if script:element(id) then
				return script:element(id)
			end
		end
	end
	if not SurvivorModeBase.Enable then
		_f_GroupAIStateBase__update_point_of_no_return(self, t, dt)
		return
	end
	self._point_of_no_return_timer = self._point_of_no_return_timer - dt
	if not self._point_of_no_return_id or not get_mission_script_element(self._point_of_no_return_id) then
		if Utils:IsInHeist() then
			if self._point_of_no_return_timer <= 0 then
				managers.network:session():send_to_peers("mission_ended", false, 0)
				game_state_machine:change_state_by_name("gameoverscreen")
			else
				managers.hud:feed_point_of_no_return_timer(self._point_of_no_return_timer)
			end
		end
	else
		_f_GroupAIStateBase__update_point_of_no_return(self, t, dt)
	end
end

function GroupAIStateBase:add_time_to_no_return(time)
	local _no_return_time = self._point_of_no_return_timer or 0
	local _timer = math.floor(_no_return_time)
	if _timer <= 0 then
		return
	end
	_timer = _timer + time
	if _timer > SurvivorModeBase.Cap_Time then
		_timer = SurvivorModeBase.Cap_Time
	end
	self:set_point_of_no_return_timer(_timer, 0)
end

function GroupAIStateBase:get_no_return_timer(time)
	return self._point_of_no_return_timer or 0
end