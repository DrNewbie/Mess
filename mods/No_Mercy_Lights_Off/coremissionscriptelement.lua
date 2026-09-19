core:module("CoreMissionScriptElement")
core:import("CoreXml")
core:import("CoreCode")
core:import("CoreClass")

MissionScriptElement = MissionScriptElement or class()

if MissionScriptElement and Global.game_settings and Global.game_settings.level_id and Global.game_settings.level_id == "nmh" then
	Hooks:PostHook(MissionScriptElement, "on_executed", "F_"..Idstring("PostHook:MissionScriptElement:on_executed:No Mercy Lights Off"):key(), function(self)
		if Global.game_settings and Global.game_settings.level_id and Global.game_settings.level_id == "nmh" then
			if self:editor_name() == "lightsON" or self:editor_name() == "startup"  then
				local ele = self:get_mission_element(103469)
				if ele then
					ele:on_executed()
				end
			end
		end
	end )
end