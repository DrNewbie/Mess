local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

for character, tweaks in pairs(tweak_data.character) do
	if type(tweaks) == 'table' and tweaks.move_speed and character ~= 'presets' then
		tweaks.hostage_move_speed = tweaks.surrender and tweaks.surrender ~= tweak_data.character.presets.surrender.special and tweak_data.character.civilian.hostage_move_speed or 1
	end
end

local mic_original_copbrain_onalarmpagerinteraction = CopBrain.on_alarm_pager_interaction
function CopBrain:on_alarm_pager_interaction(status, player)
	if not managers.groupai:state():whisper_mode() or not self._alarm_pager_data then
		return
	end

	mic_original_copbrain_onalarmpagerinteraction(self, status, player)

	if status == 'complete' and not self:_chk_enable_bodybag_interaction() then
		self._unit:interaction():set_tweak_data('hostage_convert')
		self._unit:interaction():set_active(true, true, false)
	end
end

function CopBrain:on_intimidated_follow_objective_failed(unit)
	if not unit:character_damage():dead() then
		local data = self._logic_data
		if not data.objective or data.objective.is_default or self._current_logic_name == 'intimidated' then
			self._unit:base().mic_destination = nil
			local owner = data.mic_is_being_moved
			self:on_hostage_move_interaction(alive(owner) and owner or nil, 'fail')
		end
	end
end

function CopBrain:on_hostage_move_interaction(interacting_unit, command)
	if command == 'move' then
		if self._current_logic_name ~= 'intimidated' or not alive(interacting_unit) then
			return
		end

		local following_hostages = managers.groupai:state():get_following_hostages(interacting_unit)
		if following_hostages and table.size(following_hostages) >= tweak_data.player.max_nr_following_hostages then
			return
		end

		self._unit:movement()._cool = true
		local action = self._unit:movement():action_request({ type = 'act', variant = 'stand', body_part = 1, clamp_to_graph = true })
		if not action then
			return
		end

		self._logic_data.internal_data.aggressor_unit = interacting_unit
		self._logic_data.mic_is_being_moved = interacting_unit
		self._unit:base().mic_is_being_moved = interacting_unit

		self._unit:movement():set_stance('ntl', nil, true)
		local follow_objective = {
			type = 'follow',
			follow_unit = interacting_unit,
			nav_seg = interacting_unit:movement():nav_tracker():nav_segment(),
			interrupt_dis = 0,
			interrupt_health = 0,
			lose_track_dis = 2000,
			distance = 500,
			stance = 'ntl',
			fail_clbk = callback(self, self, 'on_intimidated_follow_objective_failed')
		}
		self:set_objective(follow_objective)

		self._unit:interaction():set_tweak_data('hostage_stay')
		self._unit:interaction():set_active(true, true)
		interacting_unit:sound():say('f38_any', false, true)
		managers.groupai:state():on_hostage_follow(interacting_unit, self._unit, true)

		local has_friendly_contour = false
		for _, setup in pairs(self._unit:contour()._contour_list or {}) do
			if setup.type == 'friendly' then
				has_friendly_contour = true
				break
			end
		end
		if not has_friendly_contour then
			self._following_hostage_contour_id = self._unit:contour():add('friendly', true)
		end

	elseif command == 'stay' or command == 'fail' then
		if self._current_logic_name == 'intimidated' then
			return
		end

		self._unit:movement()._cool = false
		self:set_objective({ type = 'surrender', amount = 1, aggressor_unit = interacting_unit })

		local blocks = { light_hurt = -1, hurt = -1, heavy_hurt = -1, hurt_sick = -1, action = -1, walk = -1 }
		local action = self._unit:movement():action_request({ type = 'act', variant = 'tied', body_part = 1, clamp_to_graph = true, blocks = blocks })
		if not action then
			return
		end

		self._unit:movement():set_stance('ntl', nil, true)
		self._unit:interaction():set_tweak_data('hostage_convert')
		self._unit:interaction():set_active(true, true)

		if alive(interacting_unit) and command == 'stay' then
			interacting_unit:sound():say('f02x_sin', false, true)
		end

		if self._following_hostage_contour_id then
			self._unit:contour():remove_by_id(self._following_hostage_contour_id, true)
			self._following_hostage_contour_id = nil
		end

		managers.groupai:state():on_hostage_follow(self._unit:base().mic_is_being_moved, self._unit, false)
		self._logic_data.mic_is_being_moved = nil
		self._logic_data.mic_destination = nil
		self._unit:base().mic_is_being_moved = nil
		self._unit:base().mic_destination = nil
	end

	return true
end

local mic_original_copbrain_clbkdeath = CopBrain.clbk_death
function CopBrain:clbk_death(my_unit, damage_info)
	if self._logic_data.mic_is_being_moved then
		if self._current_logic_name ~= 'intimidated' then
			if self._following_hostage_contour_id then
				self._unit:contour():remove_by_id(self._following_hostage_contour_id, true)
				self._following_hostage_contour_id = nil
			end
			managers.groupai:state():on_hostage_state(false, self._unit:key(), true)
			managers.groupai:state():on_hostage_follow(self._logic_data.mic_is_being_moved, self._unit, false)
		end
		self._unit:base().mic_is_being_moved = nil
		self._logic_data.mic_is_being_moved = nil
	end

	mic_original_copbrain_clbkdeath(self, my_unit, damage_info)
end

local _restart = _G.mic_restart

function CopBrain:mic_on_intimidated(aggressor_unit, secondary)
	local data = self._logic_data
	CopLogicIdle.mic_reset_rebellion(data)

	if aggressor_unit and data.mic_is_being_moved == aggressor_unit then
		if secondary then
			local peer_id = managers.network:session():peer_by_unit(aggressor_unit):id()
			local wp_position = managers.hud and managers.hud:gcw_get_custom_waypoint_by_peer(peer_id)
			if not wp_position then
				self:on_hostage_move_interaction(nil, 'stay')
				return
			end
			if data.mic_destination and mvector3.equal(wp_position, data.mic_destination) then
				-- qued
			else
				wp_position = mvector3.copy(wp_position)
				data.mic_destination = wp_position
				self._unit:base().mic_destination = wp_position
				self._unit:movement():set_attention(nil)
				self:set_objective({
					type = 'dont_follow',
					nav_seg = managers.navigation:get_nav_seg_from_pos(wp_position),
					pos = wp_position,
				})
				_restart(self._unit)
			end

		else
			data.mic_destination = nil
			self._unit:base().mic_destination = nil
			self._unit:movement():set_attention({unit = aggressor_unit})
			self:set_objective({
				type = 'follow',
				follow_unit = aggressor_unit,
				nav_seg = aggressor_unit:movement():nav_tracker():nav_segment(),
				called = true,
				pos = aggressor_unit:movement():nav_tracker():field_position(),
			})
			_restart(self._unit)
		end
	end
end

function CopBrain:on_mic_state_changed(state)
	if state then
		if self._alert_listen_key then
			managers.groupai:state():remove_alert_listener(self._alert_listen_key)
		else
			self._alert_listen_key = 'CopBrain' .. tostring(self._unit:key())
		end
		local alert_listen_filter = managers.groupai:state():get_unit_type_filter('law_enforcer')
		local alert_types = {
			bullet = true,
			vo_cbt = true,
			vo_intimidate = true,
			aggression = true,
			explosion = true
		}
		managers.groupai:state():add_alert_listener(self._alert_listen_key, callback(self, self, 'on_alert'), alert_listen_filter, alert_types, self._unit:movement():m_head_pos())
	else
		self:on_cool_state_changed(false)
	end
end

local mic_original_copbrain_setimportant = CopBrain.set_important
function CopBrain:set_important(state)
	if self._logic_data.mic_is_being_moved then
		state = true
	end
	mic_original_copbrain_setimportant(self, state)
end
