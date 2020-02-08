local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

core:module('CoreMissionManager')

local fs_original_missionmanager_update = MissionManager.update
function MissionManager:update(t, dt)
	self.project_instigators_cache = {}
	fs_original_missionmanager_update(self, t, dt)
end

function MissionScript:is_debug()
	return false
end
