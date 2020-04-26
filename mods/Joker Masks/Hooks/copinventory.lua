Hooks:PostHook(CopInventory, "init", "JOKERMASK_CopInventoryInit", function(self)
	self._JOKER_mask_visibility = false
	self._ids_mask = self._ids_mask or "NONE"
end)

function CopInventory:JOKERMASK_Can_I_Have_Mask()
	if not self._ids_mask or not self._ids_mask:find("masks") or self._ids_mask:find("NONE") then
		return false
	end
	if not DB:has(Idstring("unit"), Idstring(self._ids_mask)) then
		return false
	end
	if not self._unit or not alive(self._unit) or self._unit == managers.player:player_unit() then
		return false
	end
	return true
end

function CopInventory:JOKERMASK_apply_mask(_ids_mask, _mask_blueprint)
	if _ids_mask then
		self._ids_mask = _ids_mask
		self._mask_blueprint = type(_mask_blueprint) == "table" and _mask_blueprint.blueprint or nil
	end
	if not self:JOKERMASK_Can_I_Have_Mask() then
		return
	end
	self._JOKER_mask_visibility = true
	managers.dyn_resource:load(Idstring("unit"), Idstring(self._ids_mask), managers.dyn_resource.DYN_RESOURCES_PACKAGE, callback(self, self, "JOKERMASK_clbk_mask_unit_loaded"))
end

function CopInventory:JOKERMASK_clbk_mask_unit_loaded(status, asset_type, asset_name)
	self._JOKER_mask_unit_loaded = status
	self:JOKERMASK_reset_JOKER_mask_visibility()
end

function CopInventory:JOKERMASK_unload_mask()
	if not self:JOKERMASK_Can_I_Have_Mask() then
		return
	end
	managers.dyn_resource:unload(Idstring("unit"), Idstring(self._ids_mask), DynamicResourceManager.DYN_RESOURCES_PACKAGE, false)
	self._ids_mask = nil
end

function CopInventory:JOKERMASK_reset_JOKER_mask_visibility()
	self:JOKERMASK_set_JOKER_mask_visibility(self._JOKER_mask_unit_loaded and true or false)
end

function CopInventory:JOKERMASK_pre_destroy(unit)
	CopInventory.super.pre_destroy(self, unit)
	self:JOKERMASK_unload_mask()
end

function CopInventory:JOKERMASK_set_JOKER_mask_visibility(state)
	if not self:JOKERMASK_Can_I_Have_Mask() then
		return
	end
	local character_name = managers.criminals:character_name_by_unit(self._unit)
	if character_name then
		return
	end
	self._JOKER_mask_visibility = state
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
	local mask_unit = World:spawn_unit(Idstring(self._ids_mask), mask_align:position(), mask_align:rotation())
	if self._mask_blueprint then
		self._mask_blueprint.material = self._mask_blueprint.material or {}
		self._mask_blueprint.color = self._mask_blueprint.color or {}
		self._mask_blueprint.pattern = self._mask_blueprint.pattern or {}
		self._mask_blueprint.material.id = self._mask_blueprint.material.id or "plastic"
		self._mask_blueprint.color.id = self._mask_blueprint.color.id or "nothing"
		self._mask_blueprint.pattern.id = self._mask_blueprint.pattern.id or "no_color_no_material"
		mask_unit:base():apply_blueprint(self._mask_blueprint)
	end
	if not mask_unit or not alive(mask_unit) then
		return
	end
	self._unit:link(mask_align:name(), mask_unit, mask_unit:orientation_object():name())
	self._mask_unit = mask_unit
end