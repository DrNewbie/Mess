core:module("CoreMissionScriptElement")
core:import("CoreXml")
core:import("CoreCode")
core:import("CoreClass")

MissionScriptElement = MissionScriptElement or class()

if not MissionScriptElement or not Global.game_settings or not Global.game_settings.level_id or not Global.game_settings.level_id == "chill_combat" then
	return
end

IS_SpawnYourGang = false

local SpawnYourGang_MissionScriptElement_on_executed = MissionScriptElement.on_executed
function MissionScriptElement:on_executed(...)
	if not self._values.enabled then
		return
	end
	if not IS_SpawnYourGang and self._id == 100915 then
		IS_SpawnYourGang = true
		local _runE = function (_run)
			local _runList = {}
			for _, script in pairs(managers.mission:scripts()) do
				for idx, element in pairs(script:elements()) do
					idx = tostring(idx)
					if table.contains(_run, idx) then
						if element then
							table.insert(_runList, element)
						end
					end
				end
			end
			for _, element in pairs(_runList) do
				element._values.enabled = true
				element:on_executed()
			end
		end
		_runE({"100009"})
	end
	return SpawnYourGang_MissionScriptElement_on_executed(self, ...)
end