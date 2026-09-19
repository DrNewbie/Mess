local mod_ids = Idstring("Use parachute to avoid fall death"):key()
local is_loaded = PackageManager:loaded("packages/narr_jerry2")
local old_1 = "__old_"..Idstring("old_1:"..mod_ids):key()
local old_2 = "__old_"..Idstring("old_2:"..mod_ids):key()
local old_3 = "__old_"..Idstring("old_3:"..mod_ids):key()
local old_4 = "__old_"..Idstring("old_4:"..mod_ids):key()
local old_5 = "__old_"..Idstring("old_5:"..mod_ids):key()

if PlayerStandard and RequiredScript == "lib/units/beings/player/states/playerstandard" then
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

if IngameParachuting and RequiredScript == "lib/states/ingameparachuting" then
	IngameParachuting[old_1] = IngameParachuting[old_1] or IngameParachuting.at_exit
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
		self[old_1](self, ...)
	end
end

if HuskPlayerMovement and RequiredScript == "lib/units/beings/player/huskplayermovement" then
	HuskPlayerMovement[old_2] = HuskPlayerMovement[old_2] or HuskPlayerMovement._cleanup_previous_state
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
		self[old_2](self, previous_state, ...)
	end
	HuskPlayerMovement[old_3] = HuskPlayerMovement[old_3] or HuskPlayerMovement._sync_movement_state_parachute
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
		self[old_3](self, event_descriptor, ...)
	end
end

if PlayerParachutingVR and RequiredScript == "lib/units/beings/player/states/vr/playerparachutingvr" then
	local __enter = PlayerParachuting.enter
	PlayerParachutingVR[old_4] = PlayerParachutingVR[old_4] or PlayerParachutingVR.enter
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
		self[old_4](self, ...)
	end
end

if PlayerMovement and RequiredScript == "lib/units/beings/player/playermovement" then
	PlayerMovement[old_5] = PlayerMovement[old_5] or PlayerMovement.change_state
	function PlayerMovement:change_state(name, ...)
		if not is_loaded and tostring(name) == "jerry2" then
			local exit_data = nil
			if self._current_state then
				exit_data = self._current_state:exit(self._state_data, name)
			end
			local new_state = self._states[name]
			self._current_state = new_state
			self._current_state_name = name
			self._state_enter_t = managers.player:player_timer():time()
			new_state:enter(self._state_data, exit_data)
			return
		end
		self[old_5](self, name, ...)
	end
end