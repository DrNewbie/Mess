Hooks:PostHook(CopInventory, "init", "JOKERMASK_SetMaskInit", function(cop)
	cop._mask_visibility = false
	cop._ids_mask = cop._ids_mask or "NONE"
end)

function CopInventory:JOKERMASK_Can_I_Have_Mask()
	if not self._ids_mask or not self._ids_mask:find("masks") or self._ids_mask:find("NONE") then
		return false
	end
	return true
end

function CopInventory:JOKERMASK_apply_mask(_ids_mask)
	if _ids_mask then
		self._ids_mask = _ids_mask
	end
	if not self:JOKERMASK_Can_I_Have_Mask() then
		return
	end
	self._mask_visibility = true
	managers.dyn_resource:load(Idstring("unit"), Idstring(self._ids_mask), managers.dyn_resource.DYN_RESOURCES_PACKAGE, callback(self, self, "JOKERMASK_clbk_mask_unit_loaded"))
end

function CopInventory:JOKERMASK_clbk_mask_unit_loaded(status, asset_type, asset_name)
	self._mask_unit_loaded = status
	self:JOKERMASK_reset_mask_visibility()
end

function CopInventory:JOKERMASK_unload_mask()
	if not self:JOKERMASK_Can_I_Have_Mask() then
		return
	end
	managers.dyn_resource:unload(Idstring("unit"), Idstring(self._ids_mask), DynamicResourceManager.DYN_RESOURCES_PACKAGE, false)
	self._ids_mask = nil
end

function CopInventory:JOKERMASK_reset_mask_visibility()
	self:JOKERMASK_set_mask_visibility(self._mask_visibility and true or false)
end

function CopInventory:JOKERMASK_pre_destroy(unit)
	CopInventory.super.pre_destroy(self, unit)
	self:JOKERMASK_unload_mask()
end

function CopInventory:JOKERMASK_set_mask_visibility(state)
	if not self:JOKERMASK_Can_I_Have_Mask() then
		return
	end
	if self._unit == managers.player:player_unit() then
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
			local name = self._mask_unit:name()
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
	local mask_unit = World:spawn_unit(Idstring(self._ids_mask), mask_align:position(), mask_align:rotation())
	if not mask_unit or not alive(mask_unit) then
		return
	end
	self._unit:link(mask_align:name(), mask_unit, mask_unit:orientation_object():name())
	self._mask_unit = mask_unit
	--[[
	local backside = World:spawn_unit(Idstring("units/payday2/masks/msk_backside/msk_backside"), mask_align:position(), mask_align:rotation())
	self._mask_unit:link(self._mask_unit:orientation_object():name(), backside, backside:orientation_object():name())
	]]
end