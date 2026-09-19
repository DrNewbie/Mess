Hooks:PostHook(AmmoBagBase, "setup", "AmmoBagBase_setup_MAXAMMO", function(self)
	self._max_ammo_amount = self._ammo_amount
end)

local AmmoBagBase_take_ammo_Orrr = AmmoBagBase.take_ammo
function AmmoBagBase:take_ammo(unit, second_interact)
	if second_interact then
		if self._empty then
			return false, false
		end
		local inventory = unit:inventory()
		if inventory then
			local givee = 0.10
			local costt = 0.20
			for _, weapon in pairs(inventory:available_selections()) do
				if weapon.unit:base():get_ammo_ratio() < costt then
					managers.hud:show_hint({text = "Your ammo isn't enough"})
					return false, false
				end
			end
			for index, weapon in pairs(inventory:available_selections()) do
				weapon.unit:base():remove_ammo(1 - costt)
				managers.hud:set_ammo_amount(index, weapon.unit:base():ammo_info())
			end
			if self._ammo_amount + givee > self._max_ammo_amount then
				givee = self._max_ammo_amount - self._ammo_amount - 0.01
			end
			managers.network:session():send_to_peers_synched("sync_ammo_bag_ammo_taken", self._unit, -1*givee)
			self._ammo_amount = math.clamp(self._ammo_amount + givee, 0, self._max_ammo_amount)
			if self._ammo_amount <= 0 then
				self:_set_empty()
			else
				self:_set_visual_stage()
			end
		end
		return false, false
	end
	return AmmoBagBase_take_ammo_Orrr(self, unit, second_interact)
end