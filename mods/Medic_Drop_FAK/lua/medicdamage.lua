Hooks:PostHook(MedicDamage, "init", "MedicDropFAK_MedicDamage_init", function(self, ...)
	if math.random(1, 10) >= 2 then
		self:set_pickup(nil)
	else
		self:set_pickup("medic_fak")
	end
end )