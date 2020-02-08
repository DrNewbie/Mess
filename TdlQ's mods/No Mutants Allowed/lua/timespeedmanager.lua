local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local nma_original_timespeedmanager_playeffect = TimeSpeedManager.play_effect
function TimeSpeedManager:play_effect(...)
	NoMA.timespeedchange_t = self._game_timer:time()
	return nma_original_timespeedmanager_playeffect(self, ...)
end

local nma_original_timespeedmanager_stopeffect = TimeSpeedManager.stop_effect
function TimeSpeedManager:stop_effect(...)
	NoMA.timespeedchange_t = self._game_timer:time()
	return nma_original_timespeedmanager_stopeffect(self, ...)
end
