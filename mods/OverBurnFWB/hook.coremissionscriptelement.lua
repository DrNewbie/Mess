core:module("CoreMissionScriptElement")
core:import("CoreXml")
core:import("CoreCode")
core:import("CoreClass")

MissionScriptElement = MissionScriptElement or class()

if Network and Network:is_client() then
	return
end

local OverBurnBlock = nil

Hooks:PreHook(MissionScriptElement, "execute_on_executed", "F_"..Idstring("PreHook:MissionScriptElement:execute_on_executed:OverBurn"):key(), function(self)
	if not Global.game_settings or Global.game_settings.level_id ~= "red2" then
	
	else		
		if not OverBurnBlock and self._values.on_executed and self._id == 101299 and self._editor_name == "logic_link_018" then
			OverBurnBlock = true
			for ii, params in ipairs(self._values.on_executed) do
				if params and params.id == 101324 then
					self._values.on_executed[ii].delay = 2000
				end
			end
		end
	end
end)