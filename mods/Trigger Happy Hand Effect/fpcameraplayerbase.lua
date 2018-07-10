Hooks:PostHook(FPCameraPlayerBase, "init", "is_trigger_happy_hand_effect", function(self, unit, t, dt)
	if managers.player:has_category_upgrade("pistol", "stacking_hit_damage_multiplier") then
		self._is_trigger_happy_hand_effect = true
		self._trigger_happy_hand_effect_list = {}
		self._last_trigger_happy_property = 0
	end
end)

Hooks:PostHook(FPCameraPlayerBase, "update", "trigger_happy_hand_effect_update", function(self, unit, t, dt)
	if self._is_trigger_happy_hand_effect then
		local ans = managers.player:get_property("trigger_happy", 1)
		if self._last_trigger_happy_property ~= ans then
			if ans == 1 then
				for k, v in pairs(self._trigger_happy_hand_effect_list) do
					World:effect_manager():fade_kill(v)
					self._trigger_happy_hand_effect_list[k] = nil
				end
			else
				for k , v in ipairs({"a_weapon_left", "a_weapon_right"}) do					
					table.insert(self._trigger_happy_hand_effect_list, World:effect_manager():spawn({
						effect = Idstring("effects/payday2/particles/weapons/saw/sawing"),
						parent = self._parent_unit:camera()._camera_unit:get_object(Idstring(v))
					}))
				end
			end
			self._last_trigger_happy_property = ans
		end
	end
end)