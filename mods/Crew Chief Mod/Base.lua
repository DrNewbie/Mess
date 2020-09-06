local mod_ids = Idstring('Crew Chief Mod'):key()
local __dt = '__dt_'..Idstring(mod_ids..'__dt'):key()

Hooks:PostHook(PlayerMovement, 'init', 'F_'..Idstring(mod_ids..':Init'):key(), function(self)
	if managers.player:has_category_upgrade('temporary', 'dmg_dampener_close_contact') then
		self[__dt] = 1
	end
end)

Hooks:PostHook(PlayerMovement, '_upd_underdog_skill', 'F_'..Idstring(mod_ids..':Loop Check'):key(), function(self, t)
	if self[__dt] and self[__dt] <= t and self._attackers and managers.player:has_inactivate_temporary_upgrade('temporary', 'dmg_dampener_close_contact') then
		self[__dt] = t + 1
		local my_pos = self._m_pos
		local underdog_data = self._underdog_skill_data
		for u_key, attacker_unit in pairs(self._attackers) do
			if not alive(attacker_unit) then
				self._attackers[u_key] = nil
			else
				local attacker_pos = attacker_unit:movement():m_pos()
				local dis_sq = mvector3.distance_sq(attacker_pos, my_pos)
				if dis_sq < underdog_data.max_dis_sq and math.abs(attacker_pos.z - my_pos.z) < underdog_data.max_vert_dis then
					managers.player:activate_temporary_upgrade('temporary', 'dmg_dampener_close_contact')
				end
			end
		end
	end
end)