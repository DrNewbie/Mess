local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local fs_original_statisticsmanager_setup = StatisticsManager._setup
function StatisticsManager:_setup(...)
	self.fs_changed_dt = TimerManager:game():time()
	return fs_original_statisticsmanager_setup(self, ...)
end

local fs_original_statisticsmanager_startsession = StatisticsManager.start_session
function StatisticsManager:start_session(...)
	self.fs_changed_dt = TimerManager:game():time()
	return fs_original_statisticsmanager_startsession(self, ...)
end

local fs_original_statisticsmanager_stopsession = StatisticsManager.stop_session
function StatisticsManager:stop_session(...)
	self.fs_changed_dt = TimerManager:game():time()
	return fs_original_statisticsmanager_stopsession(self, ...)
end
