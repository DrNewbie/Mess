local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local lpi_original_crimespreemissionbutton_getmissioncategory = CrimeSpreeMissionButton._get_mission_category
function CrimeSpreeMissionButton:_get_mission_category(mission)
	return mission.add and lpi_original_crimespreemissionbutton_getmissioncategory(self, mission) or 'short'
end
