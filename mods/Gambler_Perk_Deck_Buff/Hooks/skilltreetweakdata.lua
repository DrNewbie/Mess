Hooks:PostHook(SkillTreeTweakData, "init", "F_"..Idstring("PostHook:SkillTreeTweakData:init:Gambler Perk Deck Buff"):key(), function(self)
	if self.specializations then
		table.insert(self.specializations[10][9].upgrades, "player_loose_ammo_give_team_twice")
	end
end)