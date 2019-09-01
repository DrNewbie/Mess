function CopDamage:NepgearLASMeleeDmgBoost(attack_data)
	if attack_data.damage and attack_data.attacker_unit and attack_data.attacker_unit == managers.player:local_player() and managers.player and managers.player:Is_LAS_Nepgear() then
		for hud_i, hud_d in pairs(managers.hud._teammate_panels) do
			if hud_d._health_data then
				local char_name = managers.criminals:character_name_by_panel_id(hud_i)
				if char_name then
					local char_unit = managers.criminals:character_unit_by_name(char_name)
					if char_unit and char_unit ~= managers.player:local_player() then
						if managers.trade:is_criminal_in_custody(char_name) then
							attack_data.damage = attack_data.damage * 1.99
						else
							if not managers.groupai:state():is_unit_team_AI(char_unit) then
								local health_max = hud_d._health_data.total
								local health_current = hud_d._health_data.current
								if type(health_max) == "number" and type(health_current) == "number" then
									local health_rate = 1 - math.max(health_current / health_max, 0.0001)
									local dmg_buff = 1 + math.min(health_rate, 0.99)
									attack_data.damage = attack_data.damage * dmg_buff
								end
							end
						end
					end
				end
			end
		end
	end
	return attack_data
end

local old_damage_melee = CopDamage.damage_melee

function CopDamage:damage_melee(attack_data, ...)
	attack_data = self:NepgearLASMeleeDmgBoost(attack_data)
	return old_damage_melee(self, attack_data, ...)
end