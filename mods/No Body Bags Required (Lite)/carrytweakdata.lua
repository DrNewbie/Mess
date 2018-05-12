Hooks:PostHook(CarryTweakData, "init", "NoBodyBagsRequiredLite_Tweak", function(self, tweak_data)
	self.types.super_heavy = {
		move_speed_modifier = 0.1,
		jump_modifier = 0.1,
		can_run = false,
		throw_distance_multiplier = 0.1
	}
	self.person.type = "super_heavy"
	self.special_person.type = "super_heavy"
end)