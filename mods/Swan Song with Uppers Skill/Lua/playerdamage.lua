Hooks:PostHook(PlayerDamage, "_on_enter_swansong_event", "F_"..Idstring("PostHook:PlayerDamage:_on_enter_swansong_event:Swan Song with Uppers Skill"):key(), function(self)
	self._block_medkit_auto_revive_alt = true
end)

Hooks:PostHook(PlayerDamage, "_check_bleed_out", "F_"..Idstring("PostHook:PlayerDamage:_check_bleed_out:Swan Song with Uppers Skill"):key(), function(self)
	if self._block_medkit_auto_revive_alt and self:get_real_health() == 0 and self._bleed_out then
		local __time = Application:time()
		if __time > self._uppers_elapsed + self._UPPERS_COOLDOWN or self._uppers_elapsed == 0 then
			local auto_recovery_kit = FirstAidKitBase.GetFirstAidKit(self._unit:position())
			if auto_recovery_kit then
				self._block_medkit_auto_revive_alt = nil
				self.__auto_recovery_kit = auto_recovery_kit
				self.__auto_recovery_kit_dt = 0.8
				self.__auto_recovery_kit_damage_reduction_upgrade = self.__auto_recovery_kit._damage_reduction_upgrade 
			end
		end
	end
end)

Hooks:PostHook(PlayerDamage, "update", "F_"..Idstring("PostHook:PlayerDamage:update:Swan Song with Uppers Skill"):key(), function(self, unit, t, dt)
	if self.__auto_recovery_kit then
		if self.__auto_recovery_kit_dt then
			self.__auto_recovery_kit_dt = self.__auto_recovery_kit_dt - dt
			if self.__auto_recovery_kit_dt < 0 then
				self.__auto_recovery_kit_dt = nil
			end
		else
			self._unit:sound():play("pickup_fak_skill")
			self._disable_next_swansong = nil
			self:disable_berserker()
			self:revive(self._unit)
			if self.__auto_recovery_kit._unit and alive(self.__auto_recovery_kit._unit) then
				self.__auto_recovery_kit:take(self._unit)
			else
				self:band_aid_health()
				if self.__auto_recovery_kit_damage_reduction_upgrade then
					managers.player:activate_temporary_upgrade("temporary", "first_aid_damage_reduction")
				end
			end
			self.__auto_recovery_kit = nil
			self.__auto_recovery_kit_dt = nil
			self.__auto_recovery_kit_damage_reduction_upgrade = nil
		end
	end
end)