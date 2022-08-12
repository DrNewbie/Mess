local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()

Hooks:Add("LocalizationManagerPostInit", "F_"..Idstring("Loc::"..ThisModIds):key(), function(loc)
	loc:load_localization_file(ThisModPath.."Loc.json")
end)

Hooks:PostHook(SkillTreeTweakData, "init", "F_"..Idstring("SkillTreeTweakData::"..ThisModIds):key(), function(self)
	self.specializations[12][1].upgrades = {
		"player_yakuza_mod_armor_regen_multiplier_1"
	}
	self.specializations[12][3].upgrades = {
		"player_yakuza_mod_movement_speed_multiplier_1"
	}
	self.specializations[12][5].upgrades = {
		"player_yakuza_mod_armor_regen_health_ratio_multiplier_1"
	}
	self.specializations[12][7].upgrades = {
		"player_yakuza_mod_dodge_health_ratio_multiplier_1"
	}
end)