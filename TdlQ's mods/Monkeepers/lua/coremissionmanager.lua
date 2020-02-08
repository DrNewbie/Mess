local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

core:module('CoreMissionManager')

local mkp_original_missionscript_createelements = MissionScript._create_elements
function MissionScript:_create_elements(elements)
	local new_elements = mkp_original_missionscript_createelements(self, elements)

	local lootareas = _G.Monkeepers.lootareas
	for _, element in ipairs(self._element_groups.ElementAreaTrigger or {}) do
		if element._values.trigger_on == 'on_enter' and element._values.instigator == 'loot' then
			lootareas[element._id] = element
		end
	end

	for _, element in ipairs(self._element_groups.ElementAreaReportTrigger or {}) do
		if element._values.instigator == 'loot' then
			lootareas[element._id] = element
		end
	end

	return new_elements
end
