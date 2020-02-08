local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

tweak_data.interaction.hostage_stay.interact_distance = 150

local mic_original_baseinteractionext_canselect = BaseInteractionExt.can_select
function BaseInteractionExt:can_select(player)
	if self.tweak_data == 'hostage_move' and mic_is_enabled and not managers.groupai:state():whisper_mode() then
		if CopDamage.is_cop(self._unit:base()._tweak_table) then
			if managers.player:has_category_upgrade('player', 'convert_enemies') and not managers.player:chk_minion_limit_reached() then
				self:set_tweak_data('hostage_convert')
			end
		end
	end

	local result = mic_original_baseinteractionext_canselect(self, player)

	if self.tweak_data == 'hostage_convert' and mic_is_enabled then
		if managers.groupai:state():whisper_mode() or not managers.player:has_category_upgrade('player', 'convert_enemies') or managers.player:chk_minion_limit_reached() then
			self:set_tweak_data('hostage_move')
			result = true
		end
	end

	return result
end

local mic_original_intimitateinteractionext_interactblocked = IntimitateInteractionExt._interact_blocked
function IntimitateInteractionExt:_interact_blocked(player)
	if self._unit:brain() and (self._unit:brain()._current_logic_name == 'intimidated' or self._unit.is_tied) then
		if self.tweak_data == 'hostage_move' then
			local following_hostages = managers.groupai:state():get_following_hostages(player)
			if following_hostages and table.size(following_hostages) >= tweak_data.player.max_nr_following_hostages then
				return true, nil, 'hint_hostage_follow_limit'
			end
			return false
		elseif self.tweak_data == 'hostage_stay' then
			return false
		end
	end

	return mic_original_intimitateinteractionext_interactblocked(self, player)
end

local mic_original_intimitateinteractionext_interact = IntimitateInteractionExt.interact
function IntimitateInteractionExt:interact(player)
	if not Network:is_server() then
		if not self:can_interact(player) then
			return
		end

		if CopDamage.is_cop(self._unit:base()._tweak_table) then
			if self.tweak_data == 'hostage_move' then
				self._unit:base().mic_is_being_moved = player
				self._unit:base().mic_destination = nil
			elseif self.tweak_data == 'hostage_stay' then
				self._unit:base().mic_is_being_moved = nil
				self._unit:base().mic_destination = nil
			end
		end
	end

	mic_original_intimitateinteractionext_interact(self, player)
end
