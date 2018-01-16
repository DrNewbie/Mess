local DoctorBagBase_take_Orrr = DoctorBagBase.take
function DoctorBagBase:take(unit, second_interact)
	local Ply_Damage = unit:character_damage()
	if second_interact and Ply_Damage then
		if Ply_Damage._lives_init - Ply_Damage:get_revives() < 0 then
			unit:sound():play("pickup_ammo")
			if self._amount < self._max_amount then
				self._amount = math.clamp(self._amount + 1, 0, self._max_amount)
				managers.network:session():send_to_peers_synched("sync_doctor_bag_taken", self._unit, -1)
				managers.mission:call_global_event("player_refill_doctorbag")		
				if self._amount <= 0 then
					self:_set_empty()
				else
					self._empty = false
					self:_set_visual_stage()
				end
				Ply_Damage:force_into_bleedout()
			else
				managers.hud:show_hint({text = "Medic bag is full"})
			end
		else
			managers.hud:show_hint({text = "You don't have enough life"})
		end
		return false, false
	end
	return DoctorBagBase_take_Orrr(self, unit, second_interact)
end