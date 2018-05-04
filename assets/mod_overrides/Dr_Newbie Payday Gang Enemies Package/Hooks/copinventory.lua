Hooks:PostHook(CopInventory, "init", "Cop_SetMaskInit", function(self)
	self._mask_visibility = false
	self._mask_unit_name = self._mask_unit_name or "NONE"
end)

function CopInventory:CUS_Can_I_Have_Mask()
	if not self._mask_unit_name or not self._mask_unit_name:find("masks") or self._mask_unit_name:find("NONE") then
		return false
	end
	return true
end

function CopInventory:CUS_preload_mask()
	if not self or not self:CUS_Can_I_Have_Mask() then
		return
	end
	self._mask_visibility = true
	managers.dyn_resource:load(Idstring("unit"), Idstring(self._mask_unit_name), managers.dyn_resource.DYN_RESOURCES_PACKAGE, callback(self, self, "CUS_clbk_mask_unit_loaded"))
end

function CopInventory:CUS_clbk_mask_unit_loaded(status, asset_type, asset_name)
	self._mask_unit_loaded = status
	self:CUS_reset_mask_visibility()
end

function CopInventory:CUS_unload_mask()
	if not self:CUS_Can_I_Have_Mask() then
		return
	end
	managers.dyn_resource:unload(Idstring("unit"), Idstring(self._mask_unit_name), DynamicResourceManager.DYN_RESOURCES_PACKAGE, false)
	self._mask_unit_name = nil
end

function CopInventory:CUS_reset_mask_visibility()
	self:CUS_set_mask_visibility(self._mask_visibility and true or false)
end

function CopInventory:CUS_pre_destroy(unit)
	CopInventory.super.pre_destroy(self, unit)
	self:CUS_unload_mask()
end

function CopInventory:CUS_set_mask_visibility(state)
	if not self:CUS_Can_I_Have_Mask() then
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
	local mask_unit = World:spawn_unit(Idstring(self._mask_unit_name), mask_align:position(), mask_align:rotation())
	if not mask_unit or not alive(mask_unit) then
		return
	end
	self._unit:link(mask_align:name(), mask_unit, mask_unit:orientation_object():name())
	self._mask_unit = mask_unit
end

Hooks:PostHook(CopInventory, "CUS_preload_mask", "Post_CUS_set_mask_visibility", function(self)
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
	if (self._rnd_payday_gang or self._rnd_payday_gang_no_mask) and unit_damage then
		local rnd_payday_gang_no_mask = self._rnd_payday_gang_no_mask
		self._rnd_payday_gang_no_mask = nil
		self._rnd_payday_gang = nil
		local rnd_payday_gang_list = {
			chains = {
				sequence = "var_mtr_chains",
				mask = tweak_data.blackmarket.masks["chains"].unit
			},
			dragan = {
				sequence = "var_mtr_dragan",
				mask = tweak_data.blackmarket.masks["dragan"].unit
			},
			jacket = {
				sequence = "var_mtr_jacket",
				mask = tweak_data.blackmarket.masks["richard_returns"].unit
			},
			john_wick = {
				sequence = "var_mtr_john_wick",
				mask = tweak_data.blackmarket.masks["jw_shades"].unit
			},
			sokol = {
				sequence = "var_mtr_sokol",
				mask = tweak_data.blackmarket.masks["sokol"].unit
			},
			jiro = {
				sequence = "var_mtr_jiro",
				mask = tweak_data.blackmarket.masks["jiro"].unit
			},
			bodhi = {
				sequence = "var_mtr_bodhi",
				mask = tweak_data.blackmarket.masks["bodhi"].unit
			},
			jimmy = {
				sequence = "var_mtr_jimmy",
				mask = tweak_data.blackmarket.masks["jimmy_duct"].unit
			}
		}
		local rnd_payday_gang_data = rnd_payday_gang_list[table.random_key(rnd_payday_gang_list)]
		if unit_damage:has_sequence(rnd_payday_gang_data.sequence) then
			unit_damage:run_sequence_simple(rnd_payday_gang_data.sequence)
			if not rnd_payday_gang_no_mask then
				self._mask_visibility = false
				self._mask_unit_name = rnd_payday_gang_data.mask
				self:CUS_preload_mask()
			end
		end
	end
	if self._rnd_suit and unit_damage then
		local _var_model = "var_model_0"..tostring(math.round(math.random()*10)%7+1)
		local special_materials = tweak_data.blackmarket.characters["max"].special_materials
		local special_material = table.random(special_materials)
		local special_material_ids = Idstring(special_material)
		if unit_damage:has_sequence(_var_model) then
			unit_damage:run_sequence_simple(_var_model)
		end
		if DB:has(Idstring("material_config"), special_material_ids) then
			self._unit:set_material_config(special_material_ids, true)
		end
	end
end)