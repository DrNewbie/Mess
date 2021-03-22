local mod_ids = Idstring('Crew Chief Buff'):key()
local func3 = "F_"..Idstring("func3::"..mod_ids):key()

Hooks:PostHook(SkillTreeTweakData, "init", func3, function(self)
	table.insert(self.specializations[1][9].upgrades, "team_hostage_armor_multiplier")
end)