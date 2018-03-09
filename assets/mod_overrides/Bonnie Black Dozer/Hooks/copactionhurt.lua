Hooks:PreHook(CopActionHurt, "_start_ragdoll", "BonnieDozer_CopActionHurt_start_ragdoll", function(self)
	if self._unit:name() == Idstring("units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2") and not self._ragdolled and self._unit:damage() and self._unit:damage():has_sequence("switch_to_ragdoll") then
		local hips_body = self._unit:body("rag_Hips")
		if not hips_body then
			self._ragdolled = true
		end
	end
end)