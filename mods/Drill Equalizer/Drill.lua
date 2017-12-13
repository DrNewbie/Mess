if not Network:is_client() then
	local DrillEqualizer_create_upgrades = Drill.create_upgrades
	function Drill:create_upgrades(...)
		local player_skill = PlayerSkill
		local peers_table = managers.network and managers.network:session() and managers.network:session():peers()
		if player_skill and peers_table and peers_table[2] then
			local ans = {
				auto_repair_level_1 = 0,
				auto_repair_level_2 = 0,
				speed_upgrade_level = 0,
				silent_drill = false,
				reduced_alert = false
			}
			for p_id, peer in pairs(peers_table) do
				local unit = peer.unit and peer:unit() or nil
				if unit and alive(unit) then
					local upgrades = {
						auto_repair_level_1 = player_skill.skill_level("player", "drill_autorepair_1", 0, unit),
						auto_repair_level_2 = player_skill.skill_level("player", "drill_autorepair_2", 0, unit),
						speed_upgrade_level = player_skill.skill_level("player", "drill_speed_multiplier", 0, unit),
						silent_drill = player_skill.has_skill("player", "silent_drill", unit),
						reduced_alert = player_skill.has_skill("player", "drill_alert_rad", unit)
					}
					if not ans.silent_drill and upgrades.silent_drill then
						ans.silent_drill = true
					end
					if not ans.reduced_alert and upgrades.reduced_alert then
						ans.reduced_alert = true
					end
					if upgrades.auto_repair_level_1 > ans.auto_repair_level_1 then
						ans.auto_repair_level_1 = tonumber(upgrades.auto_repair_level_1) or 0
					end
					if upgrades.auto_repair_level_2 > ans.auto_repair_level_2 then
						ans.auto_repair_level_2 = tonumber(upgrades.auto_repair_level_2) or 0
					end
					if upgrades.speed_upgrade_level > ans.speed_upgrade_level then
						ans.speed_upgrade_level = tonumber(upgrades.speed_upgrade_level) or 0
					end
				end
			end
			return ans
		end
		return DrillEqualizer_create_upgrades(self, ...)
	end

	local DrillEqualizer_set_skill_upgrades = Drill.set_skill_upgrades
	function Drill:set_skill_upgrades(upgrades)
		if self._disable_upgrades then
			return
		end
		local peers_table = managers.network and managers.network:session() and managers.network:session():peers()
		if peers_table and peers_table[2] then
			upgrades = self:create_upgrades()
		end
		return DrillEqualizer_set_skill_upgrades(self, upgrades)
	end
end