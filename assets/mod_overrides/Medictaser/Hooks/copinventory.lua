Hooks:PostHook(CopInventory, "_chk_spawn_shield", "MedictaserGiveSequence", function(self)
	if self._unit and self._unit:damage() and self._unit:damage():has_sequence("var_mtr_medictaser") and self._unit:base()._tweak_table == "taser" then
		if math.random() < 0.5 then
			self._unit:character_damage()._heal_cooldown_t = 0
			self._unit:base()._medictaser = true
			self._unit:damage():run_sequence_simple("var_mtr_medictaser")
		end
		math.randomseed(tostring(os.time()):reverse():sub(1, 6))
	end
end)