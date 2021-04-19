Hooks:PostHook(SkillTreeTweakData, "init", "InspireSkillModSkillTweak", function(self)
	table.insert(self.skills.inspire[1].upgrades, "player_cpr_this_crew")
	table.insert(self.skills.inspire[2].upgrades, "player_long_dis_revive_mod")	
	self.skills.inspire.desc_id = "menu_inspire_mod_desc"
end)