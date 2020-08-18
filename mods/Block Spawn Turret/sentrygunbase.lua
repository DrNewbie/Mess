Hooks:PostHook(SentryGunBase, "activate_as_module", 'F_'..Idstring("PostHook:SentryGunBase:activate_as_module:MOD THAT REMOVES TURRETS ACTUALLY"):key(), function(self, team_type, tweak_table_id)
	if not self.__prepare_to_boom and not self._unit:character_damage()._dead and (tostring(team_type) == "combatant" or tostring(tweak_table_id) == "swat_van_turret_module") then
		self.__prepare_to_boom = true
		self.__prepare_to_boom_dt = 8
	end	
end)