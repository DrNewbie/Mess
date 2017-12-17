function PlayerStandard:_start_rocket_jump(t, attack_data)
	if self._running and not self.RUN_AND_RELOAD and not self._equipped_unit:base():run_and_shoot_allowed() then
		self:_interupt_action_reload(t)
		self._ext_camera:play_redirect(self:get_animation("stop_running"), self._equipped_unit:base():exit_run_speed_multiplier())
	end

	self:_interupt_action_running(t)

	self._jump_t = t
	
	local dis_vec = attack_data.dis_vec or math.UP * 470
	
	local mul = attack_data.damage * 100 * 1.5
	
	dis_vec = Vector3(dis_vec.x, dis_vec.y, -dis_vec.z)
	
	local jump_vec = dis_vec:normalized() * mul

	self._unit:mover():jump()

	if self._move_dir then
		local move_dir_clamp = self._move_dir:normalized() * math.min(1, self._move_dir:length())
		self._last_velocity_xy = move_dir_clamp * 900
		self._jump_vel_xy = mvector3.copy(self._last_velocity_xy)
	else
		self._last_velocity_xy = Vector3()
	end

	self:_perform_jump(jump_vec)
end