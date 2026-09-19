local mod_ids = Idstring('Dallas Passive Buff'):key()
local __dt = "__dt_"..Idstring('__dt'..mod_ids):key()

Hooks:PostHook(PlayerDamage, "init", "F_"..Idstring("PostHook:PlayerDamage:init:"..mod_ids):key(), function(self)
	self[__dt] = 0.1
end)

Hooks:PostHook(PlayerDamage, "update", "F_"..Idstring("PostHook:PlayerDamage:update:"..mod_ids):key(), function(self, _, _, dt)
	if self._unit and alive(self._unit) then
		if self[__dt] then
			self[__dt] = self[__dt] - dt
			if self[__dt] < 0 then
				self[__dt] = nil
			end
		else
			self[__dt] = 0.5
			local __chars = managers.groupai:state():all_char_criminals()
			for _, crim_data in pairs(__chars) do
				local __unit = crim_data.unit
				if __unit and alive(__unit) and __unit ~= self._unit and mvector3.distance(self._unit:position(), __unit:position()) <= 600 then
					local player_character = CriminalsManager.convert_old_to_new_character_workname(managers.criminals:character_name_by_unit(__unit))
					if player_character == "dallas" then
						self:restore_health(self:_max_health()*0.001, true)
						break
					end
				end
			end
		end
	end
end)