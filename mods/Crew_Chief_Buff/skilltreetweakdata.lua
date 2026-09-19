local mod_ids = Idstring('Crew Chief Buff'):key()
local func3 = "F_"..Idstring("func3::"..mod_ids):key()

Hooks:PostHook(SkillTreeTweakData, "init", func3, function(self)
	table.insert(self.specializations[1][9].upgrades, "ccb_player_hostage_armor_multiplier")
	table.insert(self.specializations[1][9].upgrades, "ccb_player_intimidate_range_mul")
	table.insert(self.specializations[1][9].upgrades, "ccb_player_long_dis_revive_range_mul")
end)