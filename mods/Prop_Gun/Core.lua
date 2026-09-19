local NowHookUnit = nil

Hooks:PostHook(PlayerStandard, '_update_foley', 'F_'..Idstring('Prop Gun::_update_foley'):key(), function(self, t, input)
	if input and self._ext_camera and self._ext_inventory and self._ext_inventory:equipped_unit() then
		if input.btn_primary_attack_state then
			self._ext_inventory:equipped_unit():base():set_ammo(0)
			local mvec_to = Vector3()
			local from_pos = self._ext_camera:position()
			mvector3.set(mvec_to, self._ext_camera:forward())
			mvector3.multiply(mvec_to, 300)
			mvector3.add(mvec_to, from_pos)
			local __slot_mask = managers.slot:get_mask("all")
			local col_ray = World:raycast("ray", from_pos, mvec_to, "slot_mask", __slot_mask)
			if col_ray and col_ray.unit then
				if not NowHookUnit then
					--Hook it
					NowHookUnit = col_ray.unit
				end
			end
			if NowHookUnit then
				--Move it
				NowHookUnit:set_position(mvec_to)
				NowHookUnit:set_enabled(false)
				NowHookUnit:set_enabled(true)
			end
		end
		if input.btn_primary_attack_release then
			NowHookUnit = nil
		end
	end
end)