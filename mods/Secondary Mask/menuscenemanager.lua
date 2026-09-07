local mask_data_ready_to_apply = {}
local mask_unit_ready_to_remove = {}

function MenuSceneManager:apply_character_mask_2()
	if type(mask_data_ready_to_apply) ~= "table" then
		return
	end
	if table.empty(mask_data_ready_to_apply) then
		return
	end
	if not alive(self._character_unit) then
		return
	end
	for this_key, use_this_mask_data in pairs(mask_data_ready_to_apply) do
		if type(use_this_mask_data) == "table" and not table.empty(use_this_mask_data) then
			local owner_unit = self._character_unit
			use_this_mask_data.owner_unit = owner_unit
			local unit_name = use_this_mask_data.unit_name
			managers.dyn_resource:load(Idstring("unit"), unit_name, DynamicResourceManager.DYN_RESOURCES_PACKAGE, function()
				local mask_id = use_this_mask_data.mask_id
				local blueprint = use_this_mask_data.blueprint
				local u_name_key = use_this_mask_data.u_name_key
				local mask_align = owner_unit:get_object(Idstring("Head"))
				local mask_unit = self:_spawn_mask(unit_name, false, mask_align:position(), mask_align:rotation(), mask_id)
				if mask_unit and alive(mask_unit) then
					mask_unit:base():apply_blueprint(blueprint, function()
						return
					end)
					owner_unit:link(mask_align:name(), mask_unit)
					use_this_mask_data.mask_unit = mask_unit
					use_this_mask_data.mask_align = mask_align
					use_this_mask_data.character_name = self._player_character_name
					use_this_mask_data.peer_id = nil
					self:update_mask_offset(use_this_mask_data)
					self:_chk_character_visibility(owner_unit)
				end
				mask_data_ready_to_apply[this_key] = nil
				table.insert(mask_unit_ready_to_remove, mask_unit)
			end)
		end
	end
end

Hooks:PostHook(MenuSceneManager, "_set_player_character_unit", "2Mask_MenuSceneManager_ReNewUnit", function(self)
	for this_key, remove_this_mask_unit in pairs(mask_unit_ready_to_remove) do
		if remove_this_mask_unit and alive(remove_this_mask_unit) then
			for _, linked_unit in ipairs(remove_this_mask_unit:children()) do
				linked_unit:unlink()
				World:delete_unit(linked_unit)
			end
			remove_this_mask_unit:unlink()
			World:delete_unit(remove_this_mask_unit)
		end
		mask_unit_ready_to_remove[this_key] = nil
	end
	self:add_one_frame_delayed_clbk(callback(self, self, "apply_character_mask_2"))
end)

function MenuSceneManager:set_character_mask_2_by_id(mask_id, blueprint)
	mask_id = managers.blackmarket:get_real_mask_id(mask_id)	
	local unit_name = managers.blackmarket:mask_unit_name_by_mask_id(mask_id)
	unit_name = Idstring(unit_name)
	local owner_unit = self._character_unit
	table.insert(mask_data_ready_to_apply, {
		owner_unit = owner_unit,
		unit_name = unit_name,
		mask_id = mask_id,
		blueprint = blueprint,
		u_name_key = tostring(owner_unit:name():key())
	})
end