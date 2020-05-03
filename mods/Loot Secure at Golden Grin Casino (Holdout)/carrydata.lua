if Global.level_data and Global.level_data.level_id and Global.level_data.level_id == "skm_cas" then
	local __ids_key = Idstring("Enable Loot Secure at Golden Grin Casino (Holdout)"):key()

	Hooks:PostHook(CarryData, "update", "F_"..Idstring("PostHook:CarryData:update:"..__ids_key):key(), function(self, unit, t, dt)
		if Global.level_data.level_id == "skm_cas" then
			if self._unit and alive(self._unit) then
				if not self["C_"..__ids_key] then
					local __target_center = Vector3(-800, -2360, 50)
					local __bag_pos = self._unit:position()
					if mvector3.distance(__target_center, __bag_pos) <= 150 then
						self["C_"..__ids_key] = true
						self["R_"..__ids_key] = 1
					end
				end
				if self["R_"..__ids_key] then
					self["R_"..__ids_key] = self["R_"..__ids_key] - dt
					if self["R_"..__ids_key] < 0 then
						self["R_"..__ids_key] = nil
						managers.loot:secure(self._carry_id, self._multiplier)
						self:destroy()
						if self._unit and alive(self._unit) then
							self._unit:set_slot(0)
						end
						if self._unit and alive(self._unit) then
							World:delete_unit(self._unit)
						end
						return
					end
				end
			end
		end
	end)
end