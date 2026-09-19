core:module("CoreElementInstance")
core:import("CoreMissionScriptElement")

ElementInstanceOutputEvent = ElementInstanceOutputEvent or class(CoreMissionScriptElement.MissionScriptElement)

if not Global.game_settings or not Global.game_settings.level_id or not Global.game_settings.level_id == "dah" then
	return
end

local CodesFailOnce = false

function ElementInstanceOutputEvent:on_executed(instigator)
	if not self._values.enabled then
		return
	end
	
	if not CodesFailOnce and managers.groupai:state():whisper_mode() and self._id == 101342 and self._editor_name == 'Correct_Code' and math.random() > 0.25 then
		for _, script in pairs(managers.mission:scripts()) do
			for idx, element in pairs(script:elements()) do
				if tostring(idx) == '101343' then
					if element then
						element:on_executed()
					end
				end
			end
		end
		CodesFailOnce = true
		return
	end

	ElementInstanceOutputEvent.super.on_executed(self, instigator)
end
