Hooks:PostHook(InteractionTweakData, "init", "SilentTripMine_InteractionTweakData", function(self, ...)
	self.trip_mine_silent = {}
	self.trip_mine_silent.icon = "equipment_trip_mine"
	self.trip_mine_silent.requires_upgrade = {
		category = "trip_mine",
		upgrade = "can_switch_on_off"
	}
end)