Hooks:PostHook(EnemyManager, "init", "F_"..Idstring("PostHook:EnemyManager:init:Enemy bodies flash"):key(), function(self)
	self._BodiesFlash_t = 0.3
end)

Hooks:PostHook(EnemyManager, "update", "F_"..Idstring("PostHook:EnemyManager:update:Enemy bodies flash"):key(), function(self, t, dt)
	local enemy_data = self._enemy_data
	local corpses = enemy_data.corpses
	if enemy_data and corpses then
		if self._BodiesFlash_t then
			self._BodiesFlash_t = self._BodiesFlash_t - dt
			if self._BodiesFlash_t < 0 then
				self._BodiesFlash_t = nil
			end
		else
			self._BodiesFlash_t = 0.3
			for u_key, u_data in pairs(corpses) do
				if not u_data._BodiesFlash then
					u_data._BodiesFlash = 1
					u_data._BodiesFlash_dt = t + 2 * math.random()
				elseif u_data._BodiesFlash == 1 then
					if u_data._BodiesFlash_dt and u_data._BodiesFlash_dt > t then
						u_data._BodiesFlash_dt = nil
						u_data._BodiesFlash = 2
					end
				elseif u_data._BodiesFlash == 2 then
					u_data._BodiesFlash = 3
					u_data.unit:set_visible(false)
				elseif u_data._BodiesFlash == 3 then
					u_data._BodiesFlash = 2
					u_data.unit:set_visible(true)
				end
			end
		end
	end
end)