Hooks:PostHook(BlackMarketTweakData, "_init_deployables", "PocketMinigundozer_init_deployables", function(self)
	self.deployables.pocket_tank_mini = {}
	self.deployables.pocket_tank_mini.name_id = "bm_equipment_pocket_tank_mini"
	self:_add_desc_from_name_macro(self.deployables)
end)