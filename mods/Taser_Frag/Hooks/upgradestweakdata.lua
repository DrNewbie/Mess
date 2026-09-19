Hooks:PostHook(UpgradesTweakData, "init", "TaserFrag_UPTweakData", function(self, ...)
	table.insert(self.level_tree[1].upgrades, "frag_taser")
end)

Hooks:PostHook(UpgradesTweakData, "_grenades_definitions", "TaserFrag_grenades_definitions", function(self, ...)
	self.definitions.frag_taser = {category = "grenade", dlc = "pd2_clan"}
end)