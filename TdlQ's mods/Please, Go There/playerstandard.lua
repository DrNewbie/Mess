local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local _secondary

local pgt_original_playerstandard_getunitintimidation_action = PlayerStandard._get_unit_intimidation_action
function PlayerStandard:_get_unit_intimidation_action(...)
	_secondary = select(select('#', ...), ...)
	return pgt_original_playerstandard_getunitintimidation_action(self, ...)
end

local pgt_original_playerstandard_getinteractiontarget = PlayerStandard._get_interaction_target
function PlayerStandard:_get_interaction_target(char_table, my_head_pos, cam_fwd)
	if _secondary then
		for _, u_data in pairs(managers.enemy:all_civilians()) do
			local unit = u_data.unit
			if alive(unit) and unit:base().pgt_is_being_moved == self._unit then
				local intimidate_range_civ = tweak_data.player.long_dis_interaction.intimidate_range_civilians
				intimidate_range_civ = intimidate_range_civ * managers.player:upgrade_value('player', 'intimidate_range_mul', 1)
				intimidate_range_civ = intimidate_range_civ * managers.player:upgrade_value('player', 'passive_intimidate_range_mul', 1)
				self:_add_unit_to_char_table(char_table, unit, 1, intimidate_range_civ, true, true, 0.01, my_head_pos, cam_fwd)
			end
		end
		_secondary = nil
	end

	return pgt_original_playerstandard_getinteractiontarget(self, char_table, my_head_pos, cam_fwd)
end

local function _restart(target_unit)
	if Network:is_server() then
		if target_unit:anim_data().move then
			target_unit:movement():action_request({
				sync = true,
				body_part = 1,
				type = 'idle'
			})
		end
		CopLogicBase._exit(target_unit, 'travel')
	end
end
_G.pgt_restart = _restart

local pgt_original_playerstandard_getintimidationaction = PlayerStandard._get_intimidation_action
function PlayerStandard:_get_intimidation_action(prime_target, char_table, amount, primary_only, detect_only, secondary)
	local target_unit = prime_target and prime_target.unit
	local prime_target_base = target_unit and target_unit:base()
	if prime_target_base and prime_target_base.pgt_is_being_moved == self._unit then
		local t = TimerManager:game():time()
		if not self._intimidate_t or t - self._intimidate_t > tweak_data.player.movement_state.interaction_delay then
			self._intimidate_t = t
			if Network:is_server() then
				CivilianLogicSurrender.pgt_reset_rebellion(target_unit:brain()._logic_data)
			else
				managers.network:session():send_to_host('long_dis_interaction', target_unit, 0, self._unit, secondary)
			end

			if secondary then
				-- send
				local wp_position = managers.hud and managers.hud:gcw_get_my_custom_waypoint()
				if not wp_position then
					if Network:is_server() then
						target_unit:brain():on_hostage_move_interaction(nil, 'stay')
					end
					return 'stop', false, prime_target
				end

				local old_dst = prime_target_base.pgt_destination
				local same_dst = old_dst and mvector3.equal(wp_position, old_dst)
				if not same_dst then
					prime_target_base.pgt_destination = mvector3.copy(wp_position)
					_restart(target_unit)
				end

				self:say_line('g18', managers.groupai:state():whisper_mode())
				if not self:_is_using_bipod() then
					self:_play_distance_interact_redirect(t, 'cmd_gogo')
				end
				return 'pgt_boost', false, prime_target -- will do nothing

			else
				-- call
				if prime_target_base.pgt_destination then
					prime_target_base.pgt_destination = nil
				end
				_restart(target_unit)
				return 'come', false, prime_target
			end
		end
	end

	return pgt_original_playerstandard_getintimidationaction(self, prime_target, char_table, amount, primary_only, detect_only, secondary)
end
