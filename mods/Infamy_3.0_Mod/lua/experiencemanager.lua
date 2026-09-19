ExperienceManager.LEVEL_CAP = Application:digest_value(101, true)

local OverLevel = { level = 99 , rank = 0 , points = 0 , xp = 0 }
function SyncXpDataLoad()
	local file = io.open(SavePath .. "OverLevel101.json", "r")
	if not file then
		return false
	end
	local fileT = file:read("*all"):gsub("%[%]","{}") 
	file:close()
	if fileT then
		OverLevel = json.decode(fileT)
	end
	return
end
SyncXpDataLoad()

function SyncXpDataSave()
	local file = io.open(SavePath .. "OverLevel100.json", "w")
	if not file then return false end
	file:write(json.encode( OverLevel ))
	file:close()
	return
end

function ExperienceManager:SyncXpData()
	local xp 	= self:xp_gained()
	local total	= self:total()
	local level = self:current_level()
	local rank	= self:current_rank()
	local points= self:next_level_data_current_points()
	local pointt= self:next_level_data_points()
	local levels_gained = self:get_levels_gained_from_xp(total)
	if level < 100 then return end
	if   OverLevel.level > level 
	and  OverLevel.rank == rank then 
		self:_set_current_level(OverLevel.level)
		self:_set_next_level_data_current_points(OverLevel.points)
		OL1X_EM_UP(self)
	else 
		OverLevel = { xp = xp , rank = rank , level = level , points = points }
		SyncXpDataSave()
	end
end

Hooks:PostHook(ExperienceManager, 'update_progress', 'F_OL1X_EM_UP', function(self)
	self:SyncXpData()
end)

OL1_EM_GE = OL1_EM_GE or ExperienceManager.give_experience
function ExperienceManager:give_experience(...)
	local data = OL1_EM_GE(self, ...)
	self:SyncXpData()
	return data
end