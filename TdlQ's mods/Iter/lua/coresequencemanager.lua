local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

core:module('CoreSequenceManager')

function EffectElement:activate_callback(env)
	local name = self:run_parsed_func(env, self._name)
	local position = self:run_parsed_func(env, self._position)
	local parent = self:run_parsed_func(env, self._parent)

	if not name then
		self:print_attribute_error('name', name, nil, true, env)
	elseif not position or not parent then
		self:print_attribute_error('position', position, nil, true, env)
	elseif DB:has('effect', name) then
		if parent then
			if type(parent) == 'string' then
				parent = env.dest_unit:get_object(parent:id())
			elseif parent.type_name ~= 'Object3D' then
				parent = nil
			end

			if not parent then
				self:print_attribute_error('parent', parent, nil, true, env)
			end
		end

		local param_map = {
			effect = name:id(),
			parent = parent,
			position = position,
			velocity = self:run_parsed_func(env, self._velocity) or Vector3()
		}
		local align = self:run_parsed_func(env, self._align)

		if align then
			if align.type_name == 'Vector3' then
				param_map.normal = align
			elseif align.type_name == 'Rotation' then
				param_map.rotation = align
			else
				self:print_attribute_error('align', align, nil, true, env)

				return
			end
		elseif not parent then
			param_map.normal = math.UP
		end

		if Application:editor() then
			CoreEngineAccess._editor_load(Idstring('effect'), param_map.effect)
		end

		local id = World:effect_manager():spawn(param_map)
		local store_id_list_var = self:run_parsed_func(env, self._store_id_list_var)

		if store_id_list_var then
			local store_id_list = env.vars[store_id_list_var]

			if not store_id_list then
				store_id_list = {}
				env.vars[store_id_list_var] = store_id_list
			end

			table.insert(store_id_list, id)

			if #store_id_list == 100 then
				self:print_error('"store_id_list_var" contains 100 elements. You aren\'t using the variable or it spawns too many effects.', true, env, nil)
			end
		end
	else
		self:print_attribute_error('name', name, nil, true, env)
		Application:error('THIS WILL CRASH SOON, SO FIX IT!\n')
	end
end
