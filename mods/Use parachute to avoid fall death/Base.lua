local mod_ids = Idstring("Use parachute to avoid fall death"):key()
local is_loaded = PackageManager:loaded("packages/narr_jerry2")

if PlayerStandard then
	Hooks:PreHook(PlayerStandard, "_update_foley", "F_"..Idstring("_update_foley:"..mod_ids):key(), function(self)
		if self._state_data.on_zipline then
		
		else
			if self._state_data.in_air then
				local __height = self._state_data.enter_air_pos_z - self._pos.z
				if __height >= 599 then
					managers.player:set_player_state("jerry2")
				end
			end
		end
	end)
end

if IngameParachuting then
	IngameParachuting.__old_at_exit = IngameParachuting.__old_at_exit or IngameParachuting.at_exit
	function IngameParachuting:at_exit(...)
		if not is_loaded then
			local player = managers.player:player_unit()
			if player then
				player:base():set_enabled(false)
			end
			managers.hud:hide(PlayerBase.PLAYER_INFO_HUD)
			managers.hud:hide(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN)
			return
		end
		self:__old_at_exit(...)
	end
end

if HuskPlayerMovement then
	HuskPlayerMovement.__old_cleanup_previous_state = HuskPlayerMovement.__old_cleanup_previous_state or HuskPlayerMovement._cleanup_previous_state
	function HuskPlayerMovement:_cleanup_previous_state(previous_state, ...)
		if not is_loaded and alive(self._parachute_unit) and (previous_state == "jerry2" or previous_state == "parachute") then
			if self._tase_effect then
				World:effect_manager():fade_kill(self._tase_effect)
			end
			local position = self._parachute_unit:position()
			local rotation = self._parachute_unit:rotation()
			self._parachute_unit:unlink()
			self._parachute_unit:set_slot(0)
			World:delete_unit(self._parachute_unit)
			self._parachute_unit = nil
			self._unit:inventory():show_equipped_unit()
			return
		end
		self:__old_cleanup_previous_state(previous_state, ...)
	end
	HuskPlayerMovement.__old_sync_movement_state_parachute = HuskPlayerMovement.__old_sync_movement_state_parachute or HuskPlayerMovement._sync_movement_state_parachute
	function HuskPlayerMovement:_sync_movement_state_parachute(event_descriptor, ...)
		if not is_loaded then
			self._unit:inventory():hide_equipped_unit()
			self:play_redirect("freefall_to_parachute")
			self._sync_look_dir = self._look_dir
			self._terminal_velocity = tweak_data.player.parachute.terminal_velocity
			self._damping = tweak_data.player.parachute.gravity / tweak_data.player.parachute.terminal_velocity
			self._gravity = tweak_data.player.parachute.gravity
			self._anim_name = "parachute"
			if self._atention_on then
				self._machine:forbid_modifier(self._look_modifier_name)
				self._machine:forbid_modifier(self._head_modifier_name)
				self._machine:forbid_modifier(self._arm_modifier_name)
				self._machine:forbid_modifier(self._mask_off_modifier_name)
				self._atention_on = false
			end
			self:set_attention_updator(self._upd_attention_parachute)
			self:set_movement_updator(self._upd_move_no_animations)
			return
		end
		self:__old_sync_movement_state_parachute(event_descriptor, ...)
	end
end

if PlayerParachuting then
	local __enter = PlayerParachuting.enter
	PlayerParachutingVR.__old_enter = PlayerParachutingVR.__old_enter or PlayerParachutingVR.enter
	function PlayerParachutingVR:enter(...)
		if not is_loaded then
			__enter(self, ...)
			if managers.vr:get_setting("zipline_screen") then
				self._camera_unit:base():set_hmd_tracking(false)
				managers.menu:open_menu("zipline")
				self._comfort_screen_active = true
			end
			managers.vr:add_setting_changed_callback("zipline_screen", self._comfort_screen_setting_changed_clbk)
			return
		end
		self:__old_enter(...)
	end
end