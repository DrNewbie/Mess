local __ModPath = ModPath

Hooks:Add("LocalizationManagerPostInit", "F_"..Idstring("Hooks:Add:LocalizationManagerPostInit:2-9 Stoic"):key(), function(loc)
	loc:load_localization_file(__ModPath.."Loc.json")
end)

Hooks:PostHook(SkillTreeTweakData, "init", "F_"..Idstring("PostHook:SkillTreeTweakData:init:2-9 Stoic"):key(), function(self)
	self.specializations[19][3].desc_id = "menu_deck_empty_desc"
	self.specializations[19][3].upgrades = {}
	self.specializations[19][5].desc_id = "menu_deck_empty_desc"
	self.specializations[19][5].upgrades = {}
	self.specializations[19][7].desc_id = "menu_deck_empty_desc"
	self.specializations[19][7].upgrades = {}
	self.specializations[19][9].desc_id = "menu_deck_empty_desc"
	self.specializations[19][9].upgrades = {}
end)