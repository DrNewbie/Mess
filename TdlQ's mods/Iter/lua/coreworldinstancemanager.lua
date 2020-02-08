local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local level_id = _G.Iter:get_level_id()

if not _G.Iter.settings['map_change_' .. level_id] then
	-- qued

elseif level_id == 'pines' then

	local itr_original_coreworldinstancemanager_getinstancemissiondata = CoreWorldInstanceManager._get_instance_mission_data
	function CoreWorldInstanceManager:_get_instance_mission_data(path)
		local result = itr_original_coreworldinstancemanager_getinstancemissiondata(self, path)

		if path == 'levels/instances/unique/san_helicopter001/world/world' then
			for _, element in ipairs(result.default.elements) do
				if element.editor_name == 'disable_loot_and_escape' then
					table.insert(element.values.elements, 100016)
					break
				end
			end
		end

		return result
	end

end
