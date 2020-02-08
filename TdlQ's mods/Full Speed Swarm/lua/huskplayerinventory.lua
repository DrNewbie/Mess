local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

function HuskPlayerInventory:add_unit_by_factory_name(factory_name, equip, instant, blueprint_string, cosmetics_string)
	local blueprint = blueprint_string and blueprint_string ~= '' and managers.weapon_factory:unpack_blueprint_from_string(factory_name, blueprint_string) or managers.weapon_factory:get_default_blueprint_by_factory_id(factory_name)
	local cosmetics = nil
	local cosmetics_data = string.split(cosmetics_string, '-')
	local weapon_skin_id = cosmetics_data[1] or 'nil'
	local quality_index_s = cosmetics_data[2] or '1'
	local bonus_id_s = cosmetics_data[3] or '0'

	if weapon_skin_id ~= 'nil' then
		local quality = tweak_data.economy:get_entry_from_index('qualities', tonumber(quality_index_s))
		local bonus = bonus_id_s == '1' and true or false
		cosmetics = {
			id = weapon_skin_id,
			quality = quality,
			bonus = bonus
		}
	end

	self:add_unit_by_factory_blueprint(factory_name, equip, instant, blueprint, cosmetics)
end

local ids_unit = Idstring('unit')
function HuskPlayerInventory:add_unit_by_factory_blueprint(factory_name, equip, instant, blueprint, cosmetics)
	local factory_weapon = tweak_data.weapon.factory[factory_name]
	local ids_unit_name = Idstring(factory_weapon.unit)

	local resource_name = self.fs_get_dynres_key(ids_unit_name)
	if not self[resource_name] then
		managers.dyn_resource:load(ids_unit, ids_unit_name, managers.dyn_resource.DYN_RESOURCES_PACKAGE, nil)
		self[resource_name] = true
	end

	local new_unit = World:spawn_unit(ids_unit_name, Vector3(), Rotation())

	local new_unit_base = new_unit:base()
	new_unit_base:set_factory_data(factory_name)
	new_unit_base:set_cosmetics_data(cosmetics)
	new_unit_base:assemble_from_blueprint(factory_name, blueprint)
	new_unit_base:check_npc()

	local setup_data = {
		user_unit = self._unit,
		ignore_units = {
			self._unit,
			new_unit
		},
		expend_ammo = false,
		autoaim = false,
		alert_AI = false,
		user_sound_variant = '1'
	}

	new_unit_base:setup(setup_data)

	local use_data = new_unit_base:get_use_data(self._use_data_alias)
	local selection_index = use_data.selection_index
	local old_selection = self._available_selections[selection_index]
	if old_selection and old_selection.unit:name() ~= ids_unit_name then
		self:fs_unload_dynres(old_selection)
	end

	if new_unit_base.AKIMBO then
		local first, second = self:_align_place(equip, new_unit, 'left_hand')
		new_unit_base:create_second_gun(nil, second and second.obj3d_name or first.obj3d_name)
	end

	self:add_unit(new_unit, equip, instant)
end
