Hooks:PostHook(FPCameraPlayerBase, "spawn_melee_item", "pulverizer_MeleeOverhaulFPCameraPlayerBasePostSpawnMeleeItem", function(self)
	local melee_entry = managers.blackmarket:equipped_melee_weapon()
	local aligns = tweak_data.blackmarket.melee_weapons[melee_entry].align_objects or {"a_weapon_left", "a_weapon_right"}
	for k , v in ipairs(aligns) do
		self._hand_effects = self._hand_effects or {}
		self._hand_effects[k] = World:effect_manager():spawn({
			effect = Idstring("effects/particles/fire/small_light_fire"),
			parent = self._parent_unit:camera()._camera_unit:get_object(Idstring(v))
		})
	end
end)

Hooks:PostHook(FPCameraPlayerBase, "unspawn_melee_item", "pulverizer_MeleeOverhaulFPCameraPlayerBasePostUnspawnMeleeItem", function(self)
	if self._hand_effects then
		for k, v in pairs(self._hand_effects) do
			World:effect_manager():fade_kill(v)
			self._hand_effects[k] = nil
		end
		self._hand_effects = nil
	end
end)