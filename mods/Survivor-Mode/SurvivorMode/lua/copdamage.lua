if Network:is_client() then
	return
end

_G.SurvivorModeBase = _G.SurvivorModeBase or {}

SurvivorModeBase.Time_Gain_On_Each_Killed = 5

local _f_CopDamage_on_death = CopDamage._on_death
function CopDamage:_on_death(...)
	if SurvivorModeBase.Enable and SurvivorModeBase.Timer_Enable then
		local enemyType = tostring(self._unit:base()._tweak_table)
		local _TimeList = {
			tank = 15,
			spooc = 10,
			taser = 7,
			shield = 7,
		}
		local _time = _TimeList[enemyType] or SurvivorModeBase.Time_Gain_On_Each_Killed
		managers.groupai:state():add_time_to_no_return(_time)
		local _total = managers.groupai:state():get_no_return_timer()
		_total = math.floor(_total)		
		SurvivorModeBase:Sync_Send("Sync_No_Return_Timer", 180)
	end
	return _f_CopDamage_on_death(self, ...)
end