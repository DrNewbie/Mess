Hooks:PostHook(CopDamage, "damage_melee", "F_"..Idstring("CopDamage:damage_melee:Toga Himiko (The Definitive Edition) [LAS] Boosts"):key(), function(self, attack_data)
	if self._dead or self._invulnerable or self._immortal then

	else
		if not attack_data.attacker_unit or not alive(attack_data.attacker_unit) or attack_data.attacker_unit ~= managers.player:player_unit() then

		else
			if not managers.player:Is_LAS_TogaHimikoNew() then

			else
				local PlyStandard = managers.player and managers.player:player_unit() and managers.player:player_unit():movement() and managers.player:player_unit():movement()._states.standard or nil
				if not PlyStandard then

				else
					if PlyStandard.__ask_to_use_this_team_da or PlyStandard.__ask_to_use_this_team_dt or PlyStandard.__ask_to_use_this_team_cd then

					else
						PlyStandard.__ask_to_use_this_team_da = self._unit:movement():team()
					end
				end
			end
		end
	end
end)