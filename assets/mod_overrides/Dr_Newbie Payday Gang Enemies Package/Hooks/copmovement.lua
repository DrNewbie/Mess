Hooks:PostHook(CopMovement, "set_character_anim_variables", "Cop_CopMovement_GetMask", function(cop)
	if cop._unit:inventory().CUS_preload_mask then
		cop._unit:inventory():CUS_preload_mask()
	end
end)