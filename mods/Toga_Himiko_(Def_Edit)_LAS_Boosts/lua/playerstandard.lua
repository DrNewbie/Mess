Hooks:PostHook(PlayerStandard, "_update_movement", "F_"..Idstring("PlayerStandard:_update_movement:Toga Himiko (The Definitive Edition) [LAS] Boosts"):key(), function(self, t, dt)
	if self._unit and alive(self._unit) and managers.player:Is_LAS_TogaHimikoNew() then
		if self.__ask_to_use_this_team_da then
			self.__old_team = self.__old_team or self._unit:movement():team()
			self._unit:movement():set_team(self.__ask_to_use_this_team_da)
			self.__ask_to_use_this_team_da = nil
			self.__ask_to_use_this_team_dt = 5
		end
		if self.__ask_to_use_this_team_dt then
			self.__ask_to_use_this_team_dt = self.__ask_to_use_this_team_dt - dt
			if self.__ask_to_use_this_team_dt <= 0 then
				self.__ask_to_use_this_team_dt = nil
				self.__ask_to_use_this_team_cd = 5
				self._unit:movement():set_team(self.__old_team)
			end
		end
		if self.__ask_to_use_this_team_cd then
			self.__ask_to_use_this_team_cd = self.__ask_to_use_this_team_cd - dt
			if self.__ask_to_use_this_team_cd <= 0 then
				self.__ask_to_use_this_team_cd = nil
				self.__ask_to_use_this_team_dt = nil
				self.__ask_to_use_this_team_da = nil
			end		
		end
	end
end)