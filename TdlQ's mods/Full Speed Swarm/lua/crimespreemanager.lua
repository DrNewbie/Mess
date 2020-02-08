local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local fs_original_crimespreemanager_servermissions = CrimeSpreeManager.server_missions
function CrimeSpreeManager:server_missions()
	local result = fs_original_crimespreemanager_servermissions(self)

	local missions_displayed_nr = tweak_data.crime_spree.gui.missions_displayed
	if #result < missions_displayed_nr then
		local _, entry = next(result)
		if entry then
			while #result < missions_displayed_nr do
				table.insert(result, entry)
			end
		end
	end

	return result
end
