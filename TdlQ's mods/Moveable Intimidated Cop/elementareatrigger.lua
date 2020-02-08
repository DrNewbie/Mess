local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

-- based on YaPh1l's fix
-- https://bitbucket.org/YaPh1l/payday-2-fixes/src/bad7a2cc9e36e53f2c2079f08db9c509cb1da525/ElementAreaTrigger.lua?at=master
local mic_original_elementareatrigger_projectinstigators = ElementAreaTrigger.project_instigators
function ElementAreaTrigger:project_instigators()
	local instigators = mic_original_elementareatrigger_projectinstigators(self)

	if self._values.instigator == 'enemies' and Network:is_server() then
		if managers.groupai:state():police_hostage_count() > 0 then
			for i = #instigators, 1, -1 do
				if instigators[i]:base().mic_is_being_moved then
					table.remove(instigators, i)
				end
			end
		end
		-- NB: converted are not part of group 'enemies' since U108
	end

	return instigators
end
