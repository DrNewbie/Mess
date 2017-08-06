local _f_PlayerStandard_get_input = PlayerStandard._get_input

local _btn_jump_press_time = 0

local _charged_jump_bool = false

local _charged_jump_ready = 3

local _charged_jump_increase = 2

function PlayerStandard:_get_input(t, ...)
	local _result = _f_PlayerStandard_get_input(self, t, ...)
	if t and type(t) == "number" and t > 0 then
		local _pressed = self._controller:get_any_input_pressed()
		local _released = self._controller:get_any_input_released()
		local _btn_jump_press = _pressed and self._controller:get_input_pressed("jump")
		local _btn_jump_release = _released and self._controller:get_input_released("jump")
		if _btn_jump_press and not _btn_jump_release then
			_btn_jump_press_time = t
		end
		if _btn_jump_release and not _btn_jump_press and _btn_jump_press_time then
			local _dt = t - _btn_jump_press_time
			if _dt > _charged_jump_ready then
				_charged_jump_bool = true
			end
			_btn_jump_press_time = 0
		end
	end
	return _result
end

local _f_PlayerStandard_check_action_jump = PlayerStandard._check_action_jump

function PlayerStandard:_check_action_jump(t, input)
	if _charged_jump_bool then
		input.btn_jump_press = true
	end
	_f_PlayerStandard_check_action_jump(self, t, input)
end

local _f_PlayerStandard_start_action_jump = PlayerStandard._start_action_jump

function PlayerStandard:_start_action_jump(t, action_start_data)
	if _charged_jump_bool then
		_charged_jump_bool = false
		action_start_data.jump_vel_z = action_start_data.jump_vel_z * _charged_jump_increase
	end
	_f_PlayerStandard_start_action_jump(self, t, action_start_data)
end