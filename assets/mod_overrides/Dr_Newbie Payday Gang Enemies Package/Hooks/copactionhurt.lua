Hooks:PreHook(CopActionHurt, "_start_ragdoll", Idstring("Dr_Newbie Payday Gang Enemies Package CopActionHurt_start_ragdoll"):key(), function(self)
	local fix = {
		[Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_medic/ene_bulldozer_medic"):key()] = true,
		[Idstring("units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2"):key()] = true,
		[Idstring("units/payday2/characters/ene_spook_1/ene_spook_1"):key()] = true,
		[Idstring("units/payday2/characters/ene_sniper_1/ene_sniper_1"):key()] = true,
		[Idstring("units/payday2/characters/ene_sniper_2/ene_sniper_2"):key()] = true
	}
	if fix[self._unit:name():key()] and not self._ragdolled and self._unit:damage() and self._unit:damage():has_sequence("switch_to_ragdoll") then
		local hips_body = self._unit:body("rag_Hips")
		if not hips_body then
			self._ragdolled = true
		end
	end
end)