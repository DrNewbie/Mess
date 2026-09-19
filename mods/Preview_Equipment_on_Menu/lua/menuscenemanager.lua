function MenuSceneManager:spawn_ZXF1AXBTZW50(equipment_id)
	if not equipment_id or type(equipment_id) ~= "string" then
		return
	end
	local equipment = tweak_data.equipments[equipment_id]
	if not equipment or type(equipment) ~= "table" or not equipment.dummy_unit then
		return
	end
	self:add_one_frame_delayed_clbk(callback(self, self, "spawn_ZXF1AXBTZW50_clbk", equipment_id))
end

function MenuSceneManager:spawn_ZXF1AXBTZW50_clbk(equipment_id)
	local equipment = tweak_data.equipments[equipment_id]
	local equipment_unit = equipment.dummy_unit
	if not equipment_unit then
		return
	end
	local ids_unit_name = Idstring(equipment_unit)
	managers.dyn_resource:load(Idstring("unit"), ids_unit_name, DynamicResourceManager.DYN_RESOURCES_PACKAGE, false)
	self._item_pos = Vector3(0, 0, 0)
	mrotation.set_zero(self._item_rot_mod)
	self._item_yaw = 0
	self._item_pitch = 0
	self._item_roll = 0
	mrotation.set_zero(self._item_rot)
	local new_unit = World:spawn_unit(ids_unit_name, self._item_pos, self._item_rot)
	self:_set_item_unit(new_unit, nil, nil, nil, nil, {
		id = equipment_id
	})
	mrotation.set_yaw_pitch_roll(self._item_rot_mod, -90, 0, 0)
	return new_unit
end