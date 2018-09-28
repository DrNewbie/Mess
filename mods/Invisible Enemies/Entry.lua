Hooks:PostHook(CopMovement, "update", "InvisibleEnemiesDoNow", function(self) 
	if self._unit then
		self._unit:set_visible(false)
		if self._unit.spawn_manager and self._unit:spawn_manager() and self._unit:spawn_manager():linked_units() then
			for unit_id, _ in pairs( self._unit:spawn_manager():linked_units() ) do
				local unit_entry = self._unit:spawn_manager():spawned_units()[unit_id]
				if unit_entry and alive(unit_entry.unit) then
					unit_entry.unit:set_visible(false)
				end
			end
		end
	end
end)
