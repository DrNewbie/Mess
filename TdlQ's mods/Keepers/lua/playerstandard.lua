local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local unit_type_minion = 22

local kpr_original_playerstandard_getinteractiontarget = PlayerStandard._get_interaction_target
function PlayerStandard:_get_interaction_target(char_table, my_head_pos, cam_fwd)
	if Keepers.enabled then
		if not self.kpr_secondary and Keepers.settings.filter_shout_at_teamai and not Keepers:IsFilterKeyPressed() then
			for i = #char_table, 1, -1 do
				if char_table[i].unit:slot() == 16 then
					table.remove(char_table, i)
				end
			end
		else
			if self.add_minions_to_teammates then
				local peer_id = managers.network:session():local_peer():id()
				for key, unit in pairs(managers.groupai:state():all_converted_enemies()) do
					if alive(unit) and unit:base().kpr_minion_owner_peer_id == peer_id and not unit:character_damage():dead() then
						self:_add_unit_to_char_table(char_table, unit, unit_type_minion, 100000, true, true, 0.01, my_head_pos, cam_fwd)
					end
				end
			end
		end
	end

	return kpr_original_playerstandard_getinteractiontarget(self, char_table, my_head_pos, cam_fwd)
end

local kpr_original_playerstandard_getintimidationaction = PlayerStandard._get_intimidation_action
function PlayerStandard:_get_intimidation_action(prime_target, char_table, amount, primary_only, detect_only, secondary)
	if not Keepers.enabled then
		-- qued
	elseif detect_only then
		-- qued
	elseif prime_target and prime_target.unit:slot() == 16 then
		local is_ok, is_teammate_ai, is_my_minion
		local my_peer_id = managers.network:session():local_peer():id()
		local unit = prime_target.unit

		local record = managers.groupai:state():all_criminals()[unit:key()]
		if record and record.ai then
			is_teammate_ai = true
			is_ok = not unit:character_damage():arrested() and not unit:character_damage():need_revive()
		else
			is_my_minion = unit:base().kpr_minion_owner_peer_id == my_peer_id
			is_ok = is_my_minion
		end

		if is_ok then
			local whisper_mode = managers.groupai:state():whisper_mode()
			local kpr_mode = whisper_mode and 2 or Keepers.settings[secondary and 'secondary_mode' or 'primary_mode'] -- force stationary if stealth
			local t = TimerManager:game():time()
			local player_need_revive = self._unit:character_damage():need_revive()
			local wp_position = managers.hud and managers.hud:gcw_get_my_custom_waypoint()

			if player_need_revive or kpr_mode == 1
				or (not secondary and Keepers.settings.filter_only_stop_calls and not Keepers:IsFilterKeyPressed())
				or (unit:base().kpr_is_keeper and not wp_position)
				or (is_teammate_ai and unit:base().kpr_following_peer_id ~= my_peer_id and not wp_position)
			then
				Keepers:SendState(unit, Keepers:GetLuaNetworkingText(my_peer_id, unit, 1), false)
				if is_my_minion and not player_need_revive then
					self._intimidate_t = t - 0.5
					return 'come', false, prime_target
				end

			else
				self._intimidate_t = t - 0.5
				if is_teammate_ai then
					DelayedCalls:Add('DelayedModKPR_bot_ok_' .. unit:id(), 1.5, function()
						if alive(unit) then
							unit:sound():say('r03x_sin')
						end
					end)
				end
				Keepers:SendState(unit, Keepers:GetLuaNetworkingText(my_peer_id, unit, kpr_mode), true)
				Keepers:ShowCovers(unit)
				if wp_position then
					self:say_line('f40_any', whisper_mode)
					if not self:_is_using_bipod() then
						self:_play_distance_interact_redirect(t, 'cmd_gogo')
					end
					return 'kpr_boost', false, prime_target -- will do nothing
				else
					return 'ai_stay', false, prime_target
				end
			end

			secondary = false
		end
	end

	return kpr_original_playerstandard_getintimidationaction(self, prime_target, char_table, amount, primary_only, detect_only, secondary)
end

local kpr_original_playerstandard_getunitintimidationaction = PlayerStandard._get_unit_intimidation_action
function PlayerStandard:_get_unit_intimidation_action(intimidate_enemies, intimidate_civilians, intimidate_teammates, only_special_enemies, intimidate_escorts, intimidation_amount, primary_only, detect_only, secondary)
	self.kpr_secondary = secondary
	self.add_minions_to_teammates = Keepers.enabled and Keepers:CanCallJokers(self._ext_movement:current_state_name()) and intimidate_teammates
	return kpr_original_playerstandard_getunitintimidationaction(self, intimidate_enemies, intimidate_civilians, intimidate_teammates, only_special_enemies, intimidate_escorts, intimidation_amount, primary_only, detect_only, secondary)
end
