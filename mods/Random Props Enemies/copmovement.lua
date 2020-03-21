function CopMovement:Re_Check_Plant_Head(__Plant_Head)
	if not DB:has(Idstring("unit"), __Plant_Head) or not PackageManager:unit_data(__Plant_Head) then
	
	else
		local them = self._unit:inventory()
		if alive(them._mask_unit) then
			for _, __linked_unit in ipairs(them._mask_unit:children()) do
				__linked_unit:unlink()
				World:delete_unit(__linked_unit)
			end
			them._mask_unit:unlink()
			World:delete_unit(them._mask_unit)
			them._mask_unit = nil
			return self:Re_Check_Plant_Head()
		else
			local __mask_align = them._unit:get_object(Idstring("Head"))
			if not __mask_align then
			
			else
				local __mask_unit = World:spawn_unit(__Plant_Head, __mask_align:position(), __mask_align:rotation())
				if not __mask_unit or not alive(__mask_unit) then
				
				else
					for index = 0, __mask_unit:num_bodies() - 1, 1 do
						local body = __mask_unit:body(index)
						if body then
							body:set_collisions_enabled(false)
							body:set_collides_with_mover(false)
							body:set_enabled(false)
						end
					end
					them._unit:link(__mask_align:name(), __mask_unit, __mask_unit:orientation_object():name())
					them._mask_unit = __mask_unit
					them._mask_unit:set_rotation(Rotation())
				end
			end
		end
	end
end

local __props_unit_ids = "ids_"..Idstring("Props_Use_Able_Units"):key()
_G[__props_unit_ids] = _G[__props_unit_ids] or nil

Hooks:PostHook(CopMovement, "post_init", "F_"..Idstring("PostHook:CopMovement:post_init:Plant Head:PwP"):key(), function(self)
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
		if not _G[__props_unit_ids] then
			_G[__props_unit_ids] = {}
			local __units = World:find_units_quick("all", managers.slot:get_mask("trip_mine_placeables"))
			for _, __hit in pairs(__units) do
				_G[__props_unit_ids][__hit:name():key()] = __hit:name()
			end
		end
	end
end)

Hooks:PostHook(CopMovement, "update", "F_"..Idstring("PostHook:CopMovement:update:Plant Head:PwP"):key(), function(self) 
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

Hooks:PostHook(CopMovement, "set_character_anim_variables", "F_"..Idstring("PostHook:CopMovement:set_character_anim_variables:Plant Head:PwP"):key(), function(self)
	if self._unit then
		self._unit:set_visible(false)
		if _G[__props_unit_ids] then
			self:Re_Check_Plant_Head(_G[__props_unit_ids][table.random_key(_G[__props_unit_ids])])		
		end
	end
end)