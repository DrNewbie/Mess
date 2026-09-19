local mod_ids = Idstring("L4D2 Pain Reliever"):key()
local func2 = "F_"..Idstring("func2::"..mod_ids):key()
local func3 = "F_"..Idstring("func3::"..mod_ids):key()
local func4 = "F_"..Idstring("func4::"..mod_ids):key()
local func5 = "F_"..Idstring("func5::"..mod_ids):key()

function PlayerDamage:l4d2_pain_reliever_delay_damage(damage, stop_hp)
	local damage_chunk = {
		tick = damage,
		stop_hp = stop_hp or 0.05
	}
	self[func3] = self[func3] or {}
	self[func4] = TimerManager:game():time() + 8
	table.insert(self[func3], damage_chunk)
end

Hooks:PreHook(PlayerDamage, '_update_delayed_damage', func2, function(self, t, dt)
	if type(self[func3]) == "table" and type(self[func4]) == "number" then
		local no_chunks = #self[func3] == 0
		local time_for_tick = t < self[func4]
		if no_chunks or time_for_tick then
		
		else
			self[func4] = t + 0.5
			for ii, damage_chunk in pairs(self[func3]) do
				if type(damage_chunk) == "table" and type(damage_chunk.stop_hp) == "number" and type(damage_chunk.tick) == "number" then
					if damage_chunk.stop_hp >= self:health_ratio() then
						self[func3][ii] = nil
					else
						self:_calc_health_damage({
							damage = damage_chunk.tick,
							variant = "delayed_tick"
						})
						break
					end
				end
			end
		end
	end
end)

Hooks:PreHook(PlayerDamage, 'recover_health', func5, function(self)
	if type(self[func3]) == "table" and type(self[func4]) == "number" then
		for ii, damage_chunk in pairs(self[func3]) do
			if type(damage_chunk) == "table" and type(damage_chunk.stop_hp) == "number" and type(damage_chunk.tick) == "number" then
				self[func3][ii] = {
					tick = 0,
					stop_hp = 999
				}
			end
		end
	end
end)