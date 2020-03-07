LegendaryArmours = LegendaryArmours or {}

Hooks:PostHook(GrenadeLauncherBase, "replenish", "F_"..Idstring("GrenadeLauncherBase:replenish:TF2SoldierLASBoosts"):key(), function(self)
	local las = tostring(managers.blackmarket:equipped_player_style())
	if LegendaryArmours[las] and (las == "soldier_blu" or las == "soldier") then
		if type(self._ammo_pickup) == "table" and type(self._ammo_pickup[1]) == "number" and type(self._ammo_pickup[2]) == "number" then
			if self._ammo_pickup[2] < 0.1 then
				self._ammo_pickup = {1, 1}
			elseif self._ammo_pickup[2] < 0.5 then
				self._ammo_pickup = {2, 2}
			else
				self._ammo_pickup = {3, 3}
			end
		end
	end
end)