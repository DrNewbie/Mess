if not Global.game_settings or not Global.game_settings.level_id or not Global.game_settings.level_id == "nmh" then
	return
end

Hooks:PostHook(CopInventory, "_chk_spawn_shield", "MedictaserGiveSequence", function(self)
	if not Global.game_settings or not Global.game_settings.level_id or not Global.game_settings.level_id == "nmh" then
		return
	end
	if self._unit and self._unit:damage() then
		self._unit:base()._medic_now = true
		if self._unit:base()._tweak_table == "taser" and self._unit:damage():has_sequence("var_mtr_medictaser") then
			self._unit:damage():run_sequence_simple("var_mtr_medictaser")
		elseif self._unit:base()._tweak_table == "shield" and self._shield_unit and alive(self._shield_unit) and self._shield_unit:damage() and self._shield_unit:damage():has_sequence("var_mtr_medicshield") then
			self._shield_unit:damage():run_sequence_simple("var_mtr_medicshield")
		end
	end
end)