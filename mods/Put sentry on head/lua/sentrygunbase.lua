local mod_ids = Idstring("Put sentry on head"):key()
local func1 = "F_"..Idstring("func1::"..mod_ids):key()
local func2 = "F_"..Idstring("func2::"..mod_ids):key()
local func3 = "F_"..Idstring("func3::"..mod_ids):key()
local func5 = "F_"..Idstring("func5::"..mod_ids):key()

Hooks:PostHook(SentryGunBase, "setup", func2, function(self)
	if self:is_owner() then
		self[func3] = self._owner:position()
	end
end)

Hooks:PostHook(SentryGunBase, "update", func1, function(self)
	if self:is_owner() then
		if not self[func5] then
			self[func5] = true
		else
			self[func5] = false
			if self[func3] and self[func3] ~= self._owner:position() then
				self[func3] = self._owner:position()
				if self._owner:movement():crouching() then
					self._unit:set_position(self[func3] + Vector3(0, 0, 120))
				else
					self._unit:set_position(self[func3] + Vector3(0, 0, 170))
				end
			end
		end
		if self:ammo_ratio() < 0.15 then
			local player = self._owner
			local ammo_reduction = 0.08
			local leftover = 0
			local weapon_list = {}
			for id, weapon in pairs(player:inventory():available_selections()) do
				local ammo_ratio = weapon.unit:base():get_ammo_ratio()
				if ammo_ratio < ammo_reduction then
					leftover = leftover + ammo_reduction - ammo_ratio
					weapon_list[id] = {
						unit = weapon.unit,
						amount = ammo_ratio,
						total = ammo_ratio
					}
				else
					weapon_list[id] = {
						unit = weapon.unit,
						amount = ammo_reduction,
						total = ammo_ratio
					}
				end
			end
			local __bool_ok
			for id, data in pairs(weapon_list) do
				local ammo_left = data.total - data.amount
				if leftover > 0 and ammo_left > 0 then
					local extra_ammo = ammo_left < leftover and ammo_left or leftover
					leftover = leftover - extra_ammo
					data.amount = data.amount + extra_ammo
				end
				if data.amount > 0 then
					data.unit:base():reduce_ammo_by_procentage_of_total(data.amount)
					managers.hud:set_ammo_amount(id, data.unit:base():ammo_info())
					__bool_ok = true
				end
			end
			if __bool_ok then
				self:refill(math.min(self:ammo_ratio() + 0.15, 1))
			end
		end
	end
end)