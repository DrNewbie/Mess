Hooks:PostHook(AmmoBagBase, "update", "AmmoBagBaseUpdate"..Idstring('Silent multiuv: even more OP lmgs; AlcatToday: Suppressing Fireeeeeeeeeeeeeeee;'):key(), function(self, unit, t, dt)
	if self._unit and self._ammo_amount > 0 and not self._empty then
		local wpn = managers.player:equipped_weapon_unit()
		if wpn and wpn:base():is_category("lmg") then
			local ply_unit = managers.player:player_unit()
			local inventory = ply_unit:inventory()
			if inventory and ply_unit and mvector3.distance(ply_unit:position(), self._unit:position()) <= 500 then
				local taken = self:take_ammo(ply_unit)
				if taken then
					if self._force_reload_ammo then
						self._force_reload_ammo = self._force_reload_ammo - dt
						if self._force_reload_ammo < 0 then
							self._force_reload_ammo = nil
						end
					else
						self._force_reload_ammo = math.random()
						for _, weapon in pairs(inventory:available_selections()) do
							weapon.unit:base():on_reload()
						end
					end
				end
			end
		end
	end
end)