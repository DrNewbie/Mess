local __ids_mod_name = "F_"..Idstring("Add Green Effect to Firing"):key()

if NewRaycastWeaponBase then
	Hooks:PostHook(NewRaycastWeaponBase, "_update_stats_values", "F_"..Idstring("PostHook:NewRaycastWeaponBase:_update_stats_values:"..__ids_mod_name):key(), function(self)
		if not self[__ids_mod_name] and alive(self._unit) and self._unit:base()._blueprint and table.contains(self._unit:base()._blueprint, "wpn_fps_upg_a_dragons_breath") then
			self[__ids_mod_name] = true
		end
	end)
	Hooks:PostHook(NewRaycastWeaponBase, "_fire_raycast", "F_"..Idstring("PostHook:NewRaycastWeaponBase:_fire_raycast:"..__ids_mod_name):key(), function(self, __user_unit, __from_pos, __direction)
		if Utils and self[__ids_mod_name] then
			managers.explosion:play_sound_and_effects(
				__from_pos,
				__direction,
				1,
				CarryData.POOF_CUSTOM_PARAMS
			)
		end
	end)
end

if ShotgunBase then
	Hooks:PostHook(ShotgunBase, "_fire_raycast", "F_"..Idstring("PostHook:ShotgunBase:_fire_raycast:"..__ids_mod_name):key(), function(self, __user_unit, __from_pos, __direction)
		if Utils and self[__ids_mod_name] then
			managers.explosion:play_sound_and_effects(
				__from_pos,
				__direction,
				1,
				CarryData.POOF_CUSTOM_PARAMS
			)
		end
	end)
end