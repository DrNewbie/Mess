local ids_unit = Idstring("unit")

function MenuSceneManager:set_character_mask_2_by_id(mask_id, blueprint, unit, peer_id, character_name)
	self._mask_2_units = self._mask_2_units or {}
	
	mask_id = managers.blackmarket:get_real_mask_id(mask_id, peer_id, character_name)
	
	local unit_name = managers.blackmarket:mask_unit_name_by_mask_id(mask_id, peer_id, character_name)
	
	unit_name = Idstring(unit_name)

	local owner_unit = unit or self._character_unit
	
	local mask_data = {
		owner_unit = owner_unit,
		unit_name = unit_name,
		mask_id = mask_id,
		blueprint = blueprint,
		peer_id = peer_id,
		character_name = character_name,
		u_name_key = tostring(owner_unit:name():key())
	}
	
	managers.dyn_resource:load(Idstring("unit"), unit_name, DynamicResourceManager.DYN_RESOURCES_PACKAGE, callback(self, self, "clbk_mask_unit_2_loaded", mask_data))
	
	owner_unit:base():request_cosmetics_update()
end

function MenuSceneManager:clbk_mask_unit_2_loaded(mask_data_param, status, asset_type, asset_name)
	if not alive(mask_data_param.owner_unit) then
		return
	end
	
	local owner_unit = mask_data_param.owner_unit
	local unit_name = mask_data_param.unit_name
	local mask_id = mask_data_param.mask_id
	local blueprint = mask_data_param.blueprint
	local u_name_key = mask_data_param.u_name_key

	local mask_align = owner_unit:get_object(Idstring("Head"))
	local mask_unit = self:_spawn_mask(unit_name, false, mask_align:position(), mask_align:rotation(), mask_id)
	
	if mask_unit and alive(mask_unit) then	
		if blueprint then
			mask_unit:base():apply_blueprint(blueprint, function ()
			end)
		end
			
		self._mask_2_units[u_name_key] = {
			mask_unit = mask_unit,
			owner_unit = owner_unit,
			mask_id = mask_id
		}
		
		owner_unit:link(mask_align:name(), mask_unit)
		
		mask_data_param.mask_unit = mask_unit
		mask_data_param.mask_align = mask_align
		self:update_mask_offset(mask_data_param)
	end
end

Hooks:PostHook(MenuSceneManager, "set_character_mask", "2Mask_BlackMarketGui_ReLink", function(self)
	if type(self._mask_2_units) == "table" then
		for u_name_key, linked in pairs(self._mask_2_units) do
			if linked.mask_unit and alive(linked.mask_unit) and not alive(linked.owner_unit) then
				local do_remove = true
				for i, o_linked in pairs(self._mask_units) do
					if o_linked.unit and alive(o_linked.unit) and o_linked.unit:name():key() == u_name_key then						
						if o_linked.unit and alive(o_linked.unit) then
							local mask_align = o_linked.unit:get_object(Idstring("Head"))
							if mask_align then
								o_linked.unit:link(mask_align:name(), linked.mask_unit)
								self:update_mask_offset({
									mask_unit = linked.mask_unit,
									mask_id = linked.mask_id,
									mask_align = mask_align,
									character_name = o_linked.character_name,
									peer_id = o_linked.peer_id
								})
								do_remove = false
								break
							end
						end
					end
				end
				if do_remove then
					for _, linked_unit in ipairs(linked.mask_unit:children()) do
						if linked_unit and alive(linked_unit) then
							linked_unit:unlink()
							World:delete_unit(linked_unit)
						end
					end
					linked.mask_unit:unlink()
					World:delete_unit(linked.mask_unit)
					self._mask_2_units[u_name_key] = nil
				end
			end
		end
	end
end)

local SecondaryMask_ModPath = ModPath

if ModCore then
	ModCore:new(SecondaryMask_ModPath .. "Config.xml", true, true)
end