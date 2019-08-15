local RJ_3115ef7f11db7941 = Vector3()

Hooks:PreHook(PlayerDamage, "damage_explosion", "RJ_"..Idstring("PreHook:PlayerDamage:damage_explosion:RJ_9d3da76d29b22ce2"):key(), function(self, attack_data)
	if attack_data and attack_data.damage and self._unit and not self:incapacitated() and not self:bleed_out() and not self:arrested() then
		local dmg = attack_data.damage
		local t = TimerManager:game():time()
		local pmov = self._unit:movement()
		if pmov and not pmov:zipline_unit() then
			local psd = pmov._current_state
			if not psd or psd:_interacting() or psd:is_deploying() or psd:_changing_weapon() or psd:_is_throwing_projectile() or psd:_on_zipline() or psd:running() or psd:in_steelsight() or psd:is_equipping() or psd:_is_cash_inspecting(t) then
			
			else
				local pos_now = pmov:m_pos() + Vector3(0, 0, 25)
				local pos_hit = attack_data.position
				local push_power = mvector3.distance(pos_hit, pos_now) / 100
				if push_power < 1.1 then push_power = 20
				elseif push_power < 1.27 then push_power = 15
				elseif push_power < 1.37 then push_power = 8
				else push_power = 0
				end
				if pmov._current_state._is_jumping then
					push_power = push_power * 1.75
				end
				if push_power > 0 then
					mvector3.set(RJ_3115ef7f11db7941, pos_now - pos_hit)
					mvector3.set_z(RJ_3115ef7f11db7941, -RJ_3115ef7f11db7941.z)
					if RJ_3115ef7f11db7941.z < 500 then
						mvector3.set_z(RJ_3115ef7f11db7941, RJ_3115ef7f11db7941.z * 1.8)
					end
					local z_fix = RJ_3115ef7f11db7941.z
					push_power = push_power * math.clamp(dmg / 100, 0.3, 1.4)
					mvector3.multiply(RJ_3115ef7f11db7941, push_power)
					mvector3.set_z(RJ_3115ef7f11db7941, z_fix * 8)
					local pm = managers.player
					if pm:current_state() == "bipod" then	
						pmov._current_state:exit(nil, "standard")
						pm:set_player_state("standard")
					end
					pmov:push(RJ_3115ef7f11db7941)
				end
			end
		end
	end
end)