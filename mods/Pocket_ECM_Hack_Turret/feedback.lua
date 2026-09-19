	Hooks:PostHook(SentryGunMovement, "_upd_hacking", "PEHT_SentryGun_upd_hacking", function(self)
		if not self._tweak.ECM_HACKABLE then
			return
		end
		if not managers.player:player_unit() or not managers.player:player_unit():inventory() or not managers.player:player_unit():inventory().is_jammer_active then
			return
		end
		local is_host = Network:is_server() or Global.game_settings.single_player
		local is_hacking_active
		if (is_host and managers.player:player_unit():inventory():is_jammer_active()) or self._team.id == "hacked_turret" then
			is_hacking_active = true
		end
		if self._is_hacked then
			if not is_hacking_active then
				self._is_hacked = nil
				if is_host then
					local original_team = self._original_team
					self._original_team = nil

					self:set_team(original_team)
				end
				if self._hacked_stop_snd_event then
					self._sound_source:post_event(self._hacked_stop_snd_event)
				end
				if is_host then
					self._unit:brain():on_hacked_end()
				end
			end
		elseif is_hacking_active then
			self._is_hacked = true
			if is_host then
				local original_team = self._team
				self:set_team(managers.groupai:state():team_data("hacked_turret"))
				self._original_team = original_team
			end
			if self._hacked_start_snd_event then
				self._sound_source:post_event(self._hacked_start_snd_event)
			end
			if is_host then
				self._unit:brain():on_hacked_start()
			end
		end
	end)