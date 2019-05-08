local STOPTURRETFROMSPAWNPRODUCE = SentryGunBase.activate_as_module

function SentryGunBase:activate_as_module(team_type, tweak_table_id, ...)
	STOPTURRETFROMSPAWNPRODUCE(self, team_type, tweak_table_id, ...)
	if tostring(team_type) == "combatant" or tostring(tweak_table_id) == "swat_van_turret_module" then
		self._unit:character_damage():disable(nil, "explosion")
	end	
end