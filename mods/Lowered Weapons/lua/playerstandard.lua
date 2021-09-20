local mod_ids = Idstring(ModPath):key()
local hook1 = "F"..Idstring("hook1::"..mod_ids):key()
local __dt1 = "F"..Idstring("__dt1::"..mod_ids):key()
local bool1 = "F"..Idstring("bool1::"..mod_ids):key()
local func1 = "F"..Idstring("func1::"..mod_ids):key()

PlayerStandard[func1] = PlayerStandard[func1] or function(them)
	local __camera_base = them._camera_unit:base()
	local stance_standard = tweak_data.player.stances.default[managers.player:current_state()] or tweak_data.player.stances.default.standard
	local head_stance = them._state_data.ducking and tweak_data.player.stances.default.crouched.head or stance_standard.head
	local stances = tweak_data.player.stances.default
	local misc_attribs = stances.standard
	local offset_pos = Vector3(0, 0, -20)
	local offset_rot = Rotation(50, 0, 0)
	local duration_multiplier, duration = 1, 1
	if not type(LLWepF) == "table" or not type(LLWepF.Options) == "table" or not type(LLWepF.Options.GetValue) == "function" then
	
	else
		offset_pos = Vector3(
			LLWepF.Options:GetValue("__offset_pos_x"), 
			LLWepF.Options:GetValue("__offset_pos_y"), 
			LLWepF.Options:GetValue("__offset_pos_z")
		)
		offset_rot = Rotation(
			LLWepF.Options:GetValue("__offset_rot_x"), 
			LLWepF.Options:GetValue("__offset_rot_y"), 
			LLWepF.Options:GetValue("__offset_rot_z")
		)
		duration = LLWepF.Options:GetValue("__time_speed")
	end
	local new_fov = them:get_zoom_fov(misc_attribs) + 0
		__camera_base:clbk_stance_entered(
		misc_attribs.shoulders, 
		head_stance, 
		misc_attribs.vel_overshot, 
		new_fov, 
		misc_attribs.shakers, 
		{translation = offset_pos, rotation = offset_rot}, 
		duration_multiplier, 
		duration
	)
end

Hooks:PostHook(PlayerStandard, "_update_check_actions", hook1, function(self, __t, __dt)
	if self._camera_unit and alive(self._camera_unit) and self._camera_unit:base() and self._equipped_unit and alive(self._equipped_unit) and self._equipped_unit:base() then
		local __weap_base = self._equipped_unit:base()
		local __action_forbidden = self._shooting or self:_is_reloading() or self:in_steelsight() or self:_changing_weapon() or self:_is_meleeing() or self._use_item_expire_t or self:_interacting() or self:_is_throwing_projectile() or self:_is_deploying_bipod() or self._menu_closed_fire_cooldown > 0 or self:is_switching_stances()
		if not self[__dt1] or __action_forbidden or not __weap_base:start_shooting_allowed() then
			self[__dt1] = 3
			if not type(LLWepF) == "table" or not type(LLWepF.Options) == "table" or not type(LLWepF.Options.GetValue) == "function" then
			
			else
				self[__dt1] = LLWepF.Options:GetValue("__time_delay")
			end
			if self[bool1] then
				self:_stance_entered(false)
			end
			self[bool1] = false
		else
			if LLWepF.ForcedApplyToFov or (self[__dt1] <= 0 and not self[bool1]) then
				LLWepF.ForcedApplyToFov = false
				self[bool1] = true
				self[func1](self)
			else
				self[__dt1] = self[__dt1] - __dt
			end		
		end
	end
end)