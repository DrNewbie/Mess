local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

function PlayerInventory.fs_get_dynres_key(unit_name)
	return 'fs_dyn_resource_' .. unit_name:key()
end

local ids_unit = Idstring('unit')
function PlayerInventory:fs_unload_dynres(selection_data)
	local unit_name = selection_data.unit:name()
	local resource_name = self.fs_get_dynres_key(unit_name)
	if self[resource_name] then
		managers.dyn_resource:unload(ids_unit, unit_name, managers.dyn_resource.DYN_RESOURCES_PACKAGE, false)
		self[resource_name] = nil
	end
end

local fs_original_playerinventory_destroyallitems = PlayerInventory.destroy_all_items
function PlayerInventory:destroy_all_items()
	for _, selection_data in pairs(self._available_selections) do
		self:fs_unload_dynres(selection_data)
	end

	fs_original_playerinventory_destroyallitems(self)
end
