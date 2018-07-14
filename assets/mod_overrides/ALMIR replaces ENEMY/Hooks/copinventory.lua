Hooks:PostHook(CopInventory, "init", "Cop_SetMaskInit", function(self)
	self._mask_visibility = false
end)

function CopInventory:CUS_Can_I_Have_Mask()
	if not self._unit or not alive(self._unit) or self._unit == managers.player:player_unit() then
		return false
	end
	if self._mask_unit_name or self._rnd_suit or self._rnd_payday_gang then
		return true
	end
	return false
end

function CopInventory:CUS_preload_mask()
	if not self or not self:CUS_Can_I_Have_Mask() then
		return
	end
	
	self._mask_unit_name = "units/pd2_dlc_pines/masks/almirs_beard/msk_almirs_beard"
	self._mask_unit_name_2 = "units/pd2_crimefest_2014/oct22/masks/wayfarer/msk_wayfarer"
	
	self._mask_visibility = true
	managers.dyn_resource:load(Idstring("unit"), Idstring(self._mask_unit_name), managers.dyn_resource.DYN_RESOURCES_PACKAGE, callback(self, self, "CUS_clbk_mask_unit_loaded"))
	
	local unit_damage = self._unit:damage()
	if self._addon_mesh_obj then
		local mesh_obj = self._unit:get_object(Idstring(self._addon_mesh_obj))
		if mesh_obj then
			mesh_obj:set_visibility(true)
		end
	end
	if self._addon_body_name and unit_damage then
		if unit_damage:has_sequence(self._addon_body_name) then
			unit_damage:run_sequence_simple(self._addon_body_name)
		end
	end
	if self._addon_armor_name and unit_damage then
		if unit_damage:has_sequence(self._addon_armor_name) then
			unit_damage:run_sequence_simple(self._addon_armor_name)
		end
	end
end

function CopInventory:CUS_clbk_mask_unit_loaded(status, asset_type, asset_name)
	managers.dyn_resource:load(Idstring("unit"), Idstring(self._mask_unit_name_2), managers.dyn_resource.DYN_RESOURCES_PACKAGE, callback(self, self, "CUS_clbk_mask_unit_loaded_2"))
end

function CopInventory:CUS_clbk_mask_unit_loaded_2(status, asset_type, asset_name)
	self._mask_unit_loaded = status
	self:CUS_reset_mask_visibility()
end

function CopInventory:CUS_unload_mask()
end

function CopInventory:CUS_reset_mask_visibility()
	self:CUS_set_mask_visibility(self._mask_unit_loaded and true or false)
end

function CopInventory:CUS_pre_destroy(unit)
	CopInventory.super.pre_destroy(self, unit)
	self:CUS_unload_mask()
end

function CopInventory:CUS_set_mask_visibility(state)
	if not self:CUS_Can_I_Have_Mask() then
		return
	end
	local character_name = managers.criminals:character_name_by_unit(self._unit)
	if character_name then
		return
	end
	self._mask_visibility = state
	if alive(self._mask_unit) then
		if not state then
			for _, linked_unit in ipairs(self._mask_unit:children()) do
				linked_unit:unlink()
				World:delete_unit(linked_unit)
			end
			self._mask_unit:unlink()
			World:delete_unit(self._mask_unit)
		end
		return
	end
	if not state then
		return
	end
	local mask_align = self._unit:get_object(Idstring("Head"))
	if not mask_align then
		return
	end
	local mask_unit = World:spawn_unit(Idstring(self._mask_unit_name), mask_align:position(), mask_align:rotation())
	if not mask_unit or not alive(mask_unit) then
		return
	end
	self._unit:link(mask_align:name(), mask_unit, mask_unit:orientation_object():name())
	self._mask_unit = mask_unit
	
	if self._mask_unit_name_2 then
		local mask_unit_2 = World:spawn_unit(Idstring(self._mask_unit_name_2), mask_align:position(), mask_align:rotation())
		if not mask_unit_2 or not alive(mask_unit_2) then
			return
		end
		self._unit:link(mask_align:name(), mask_unit_2, mask_unit_2:orientation_object():name())
		self._mask_unit_2 = mask_unit_2
	end
end