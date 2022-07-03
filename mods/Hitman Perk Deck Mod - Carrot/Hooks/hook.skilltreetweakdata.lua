local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()

Hooks:Add("LocalizationManagerPostInit", "F_"..Idstring("Loc::"..ThisModIds):key(), function(loc)
	loc:load_localization_file(ThisModPath.."Loc.json")
end)

Hooks:PostHook(SkillTreeTweakData, "init", "F_"..Idstring("SkillTreeTweakData::"..ThisModIds):key(), function(self)
	self.specializations[5][1].upgrades = {
		"player_tier_armor_multiplier_1",
		"player_tier_armor_multiplier_2"
	}
	self.specializations[5][1].icon_xy = {
		6,
		0
	}
	self.specializations[5][3].upgrades = {
		"player_addition_ammo_pickup_hitman_mod"
	}
	self.specializations[5][3].icon_xy = {
		5,
		5
	}
	self.specializations[5][5].upgrades = {
		"player_addition_more_ammo_hitman_mod"
	}
	self.specializations[5][5].icon_xy = {
		5,
		5
	}
	self.specializations[5][7].upgrades = {}
	self.specializations[5][7].icon_xy = {
		900,
		900
	}
	self.specializations[5][9].upgrades = {
		"player_passive_loot_drop_multiplier"
	}
end)