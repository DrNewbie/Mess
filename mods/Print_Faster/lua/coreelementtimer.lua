core:module("CoreElementTimer")
core:import("CoreMissionScriptElement")
ElementTimer = ElementTimer or class(CoreMissionScriptElement.MissionScriptElement)
ElementTimerOperator = ElementTimerOperator or class(CoreMissionScriptElement.MissionScriptElement)

if (not Network or Network:is_server()) and ElementTimer and ElementTimerOperator and Global.game_settings and Global.game_settings.level_id == "pal" then
	Hooks:PostHook(ElementTimer, "on_script_activated", "PrintFaster_HackInitTime", function(self)
		if self._id == 102736 then
			self:timer_operation_set_time(3)
		end
	end)
	
	Hooks:PostHook(ElementTimer, "on_executed", "PrintFaster_HackSetTime_1", function(self)
		if self._id == 102736 then
			self:timer_operation_set_time(3)
		end
	end)
	
	Hooks:PostHook(ElementTimerOperator, "on_executed", "PrintFaster_HackSetTime_2", function(self)
		if self._id == 102737 then
			local element = self:get_mission_element(102736)
			element:timer_operation_set_time(3)
		end
	end)
end