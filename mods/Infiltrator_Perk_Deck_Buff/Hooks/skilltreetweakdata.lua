Hooks:PostHook(SkillTreeTweakData, "init", "F_"..Idstring("PostHook:SkillTreeTweakData:init:Infiltrator Perk Deck Buff"):key(), function(self)
	if self.specializations then
		table.insert(self.specializations[8][1].upgrades, "player_infiltrator_damage_dampener_bonus")
		table.insert(self.specializations[8][1].upgrades, "player_infiltrator_damage_dampener_bonus_cd")
	end
end)