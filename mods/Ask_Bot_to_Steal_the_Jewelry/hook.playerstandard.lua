if not Global.game_settings or not Global.game_settings.level_id or Global.game_settings.level_id ~= "jewelry_store" then
	return
end

_G.Keepers = _G.Keepers or {}

AskBot2Stealth_Runner = AskBot2Stealth_Runner or nil

function PlayerStandard:_start_action_intimidate_alt(t, secondary)
	if not self._intimidate_t or tweak_data.player.movement_state.interaction_delay < t - self._intimidate_t then
		local skip_alert = managers.groupai:state():whisper_mode()
		local voice_type, plural, prime_target = 'kpr_boost', false, {unit = AskBot2Stealth_Runner}

		if prime_target and prime_target.unit and prime_target.unit.base and (prime_target.unit:base().unintimidateable or prime_target.unit:anim_data() and prime_target.unit:anim_data().unintimidateable) then
			return
		end

		local interact_type, sound_name = nil
		local sound_suffix = plural and "plu" or "sin"

		interact_type = "cmd_come"
		local static_data = managers.criminals:character_static_data_by_unit(prime_target.unit)
		if static_data then
			local character_code = static_data.ssuffix
			sound_name = "f21" .. character_code .. "_sin"
		else
			sound_name = "f38_any"
		end
		
		Keepers:SendState(prime_target.unit, Keepers:GetLuaNetworkingText(1, prime_target.unit, Keepers.settings['secondary_mode']), true)
		Keepers:ShowCovers(prime_target.unit)
		self:_play_distance_interact_redirect(TimerManager:game():time(), 'cmd_gogo')

		self:_do_action_intimidate(t, interact_type, sound_name, skip_alert)
	end
end