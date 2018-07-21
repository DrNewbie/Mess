Hooks:PostHook(BlackMarketTweakData, "_init_deployables", "SilentTripMine_init_deployables", function(self)
	self.deployables.trip_mine_silent = {}
	self.deployables.trip_mine_silent.name_id = "bm_equipment_trip_mine_silent"
	self:_add_desc_from_name_macro(self.deployables)
end)