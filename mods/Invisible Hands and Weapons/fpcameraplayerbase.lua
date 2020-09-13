_G.__r_drawviewmodel = _G.__r_drawviewmodel or 0

Hooks:PostHook(FPCameraPlayerBase, "update", "F_"..Idstring("PostHook:FPCameraPlayerBase:update:r_drawviewmodel"):key(), function(self) 
	local __bool = false
	if _G.__r_drawviewmodel == 0 then
		__bool = false
	else
		__bool = true
	end
	if self._unit then
		self._unit:set_visible(__bool)
		if self._unit.spawn_manager and self._unit:spawn_manager() and self._unit:spawn_manager():linked_units() then
			for unit_id, _ in pairs( self._unit:spawn_manager():linked_units() ) do
				local unit_entry = self._unit:spawn_manager():spawned_units()[unit_id]
				if unit_entry and alive(unit_entry.unit) then
					unit_entry.unit:set_visible(__bool)
				end
			end
		end
		if type(self._melee_item_units) == "table" then
			for _, __melee_unit in pairs(self._melee_item_units) do
				__melee_unit:set_visible(__bool)
			end
		end
		if not __bool then
			managers.player:player_unit():inventory():hide_equipped_unit()
		else
			managers.player:player_unit():inventory():show_equipped_unit()
		end
	end
end)