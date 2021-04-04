Hooks:PostHook(BlackMarketTweakData, "_init_melee_weapons", "F_"..Idstring("Golden Spoon | Hot Rod"):key(), function(self)	
	self.melee_weapons.spoon_gold.fire_dot_data = {
		dot_trigger_chance = 1000,
		dot_damage = 30,
		dot_length = 3,
		dot_trigger_max_distance = 3000,
		dot_tick_period = 0.15
	}
end)