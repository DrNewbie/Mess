function PlayerMaskOff:_check_action_jump(t, input)
	if input.btn_jump_press then
		PlayerStandard._check_action_jump(self, t, input)
	end
end

function PlayerMaskOff:_check_action_duck(t, input)
	if input.btn_duck_press then
		if not self._state_data.ducking then
			PlayerStandard._start_action_ducking(self, t)
		elseif self._state_data.ducking then
			PlayerStandard._end_action_ducking(self, t)
		end
	end
end