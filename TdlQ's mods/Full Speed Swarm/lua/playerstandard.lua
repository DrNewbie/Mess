local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local fs_original_playerstandard_update = PlayerStandard.update
function PlayerStandard:update(t, dt)
	fs_original_playerstandard_update(self, t, dt)

	if self._equipped_visibility_timer and t > self._equipped_visibility_timer and alive(self._equipped_unit) then
		self._equipped_visibility_timer = nil
	end
end

local fs_original_playerstandard_updattention = PlayerStandard._upd_attention
function PlayerStandard:_upd_attention()
	if self._seat and self._was_unarmed and managers.groupai:state():whisper_mode() then
		local preset = {
			'pl_mask_off_friend_combatant',
			'pl_mask_off_friend_non_combatant',
			'pl_mask_off_foe_combatant',
			'pl_mask_off_foe_non_combatant'
		}
		self._ext_movement:set_attention_settings(preset)
	else
		fs_original_playerstandard_updattention(self)
	end
end

if not FullSpeedSwarm.settings.optimized_inputs or _G.IS_VR then
	return
end

local fs_original_playerstandard_init = PlayerStandard.init
function PlayerStandard:init(...)
	fs_original_playerstandard_init(self, ...)

	self.fs_wanted_pressed = {
		stats_screen = 'btn_stats_screen_press',
		duck = 'btn_duck_press',
		jump = 'btn_jump_press',
		primary_attack = 'btn_primary_attack_press',
		reload = 'btn_reload_press',
		secondary_attack = 'btn_steelsight_press',
		interact = 'btn_interact_press',
		run = 'btn_run_press',
		switch_weapon = 'btn_switch_weapon_press',
		use_item = 'btn_use_item_press',
		melee = 'btn_melee_press',
		weapon_gadget = 'btn_weapon_gadget_press',
		throw_grenade = 'btn_throw_grenade_press',
		weapon_firemode = 'btn_weapon_firemode_press',
		cash_inspect = 'btn_cash_inspect_press',
		deploy_bipod = 'btn_deploy_bipod',
		change_equipment = 'btn_change_equipment',
		interact_secondary = 'btn_interact_secondary_press',
		primary_choice1 = 'btn_primary_choice1',
		primary_choice2 = 'btn_primary_choice2',
	}
	self.fs_last_pressed_t = {}
	for _, v in pairs(self.fs_wanted_pressed) do
		self.fs_last_pressed_t[v] = -1000
	end

	self.fs_wanted_released = {
		stats_screen = 'btn_stats_screen_release',
		duck = 'btn_duck_release',
		primary_attack = 'btn_primary_attack_release',
		secondary_attack = 'btn_steelsight_release',
		interact = 'btn_interact_release',
		run = 'btn_run_release',
		use_item = 'btn_use_item_release',
		melee = 'btn_melee_release',
		throw_grenade = 'btn_projectile_release',
	}

	self.fs_wanted_downed = {
		primary_attack = 'btn_primary_attack_state',
		secondary_attack = 'btn_steelsight_state',
		run = 'btn_run_state',
		melee = 'btn_meleet_state',
		throw_grenade = 'btn_projectile_state',
	}
end

local id_2_connection_name
function PlayerStandard:fs_remap_connection_engine_ids()
	if self._controller ~= self._controller_used_for_mapping then
		self._controller_used_for_mapping = self._controller
		id_2_connection_name = self._controller._setup:get_ref_engine_ids()
	end
end

local fs_original_playerstandard_enter = PlayerStandard.enter
function PlayerStandard:enter(...)
	fs_original_playerstandard_enter(self, ...)
	self:fs_remap_connection_engine_ids()
end

function PlayerStandard:_get_input(t, dt, paused)
	local state_data = self._state_data
	local controller_enabled = state_data.controller_enabled
	local controller = self._controller
	if controller_enabled ~= controller:enabled() then
		if controller_enabled then
			state_data.controller_enabled = controller:enabled()
			return self:_create_on_controller_disabled_input()
		end
	elseif not controller_enabled then
		local input = {
			is_customized = true,
			btn_interact_release = managers.menu:get_controller():get_input_released('interact')
		}
		return input
	end
	state_data.controller_enabled = controller:enabled()

	if paused then
		self._input_paused = true
		return {}
	end

	local pressed, downed, released = controller:get_all_input_pdr()
	local pressed_nr = #pressed
	local released_nr = #released
	local downed_nr = #downed
	local has_pressed = pressed_nr > 0
	local has_released = released_nr > 0
	local has_downed = downed_nr > 0

	if not has_downed then
		self._input_paused = false
		if not has_pressed and not has_released then
			return {}
		end
	end

	local input = {
		data = { _unit = self._unit },
		any_input_pressed = has_pressed,
		any_input_released = has_released,
		any_input_downed = has_downed
	}

	if has_pressed then
		for i = 1, pressed_nr do
			local id = pressed[i]
			local cn = id_2_connection_name[id]
			local btn = self.fs_wanted_pressed[cn]
			if btn then
				input[btn] = true
				self.fs_last_pressed_t[btn] = t
			end
		end
		input.btn_projectile_press = input.btn_throw_grenade_press
		input.btn_primary_choice = input.btn_primary_choice1 and 1 or input.btn_primary_choice2 and 2 or nil
		if input.btn_stats_screen_press and self._unit:base():stats_screen_visible() then
			input.btn_stats_screen_press = false
		end
	end

	if has_released then
		for i = 1, released_nr do
			local id = released[i]
			local cn = id_2_connection_name[id]
			local btn = self.fs_wanted_released[cn]
			if btn then
				input[btn] = true
			end
		end
		if input.btn_stats_screen_release and not self._unit:base():stats_screen_visible() then
			input.btn_stats_screen_release = false
		end
	end

	if has_downed then
		for i = 1, downed_nr do
			local id = downed[i]
			local cn = id_2_connection_name[id]
			local btn = self.fs_wanted_downed[cn]
			if btn then
				input[btn] = true
			end
		end
	end

	local tupni = self._input
	if tupni then
		local current_state_name = self._ext_movement:current_state_name()
		for i = 1, #tupni do
			tupni[i]:update(t, dt, controller, input, current_state_name)
		end
	end

	return input
end

local fs_original_playerstandard_checkactionprimaryattack = PlayerStandard._check_action_primary_attack
function PlayerStandard:_check_action_primary_attack(t, input)
	if self._equipped_unit and not input.btn_primary_attack_press then
		if self.fs_last_pressed_t.btn_primary_attack_press > t - 0.2 then
			if self._equipped_unit:base():fire_mode() == 'single' then
				input.btn_primary_attack_press = true
			end
		end
	end

	local result = fs_original_playerstandard_checkactionprimaryattack(self, t, input)

	if result then
		self.fs_last_pressed_t.btn_primary_attack_press = 0
	end

	return result
end
