core:import("CoreMissionScriptElement")
core:import("CoreClass")

MissionScriptElement = MissionScriptElement or class(CoreMissionScriptElement.MissionScriptElement)

if MissionScriptElement and Global.game_settings and Global.game_settings.level_id and Global.game_settings.level_id == "hox_1" then
	_G.ControlRoomHelper = _G.ControlRoomHelper or {}
	local ControlRoomHelper = _G.ControlRoomHelper
	
	local function ControlRoomHelper_WPAttachedFunc(id, name)
		if id == 101600 and name == "func_sequence_trigger_014" then
			ControlRoomHelper:WPON()
		elseif id == 101522 and name == "done_server" then
			ControlRoomHelper:WPOFF()
		end
	end
	
	Hooks:PostHook(MissionScriptElement, "on_executed", "ControlRoomHelper_WPAttached1", function(self)
		ControlRoomHelper_WPAttachedFunc(self._id, self._editor_name)
	end)

	Hooks:PostHook(MissionScriptElement, "client_on_executed", "ControlRoomHelper_WPAttached2", function(self)
		ControlRoomHelper_WPAttachedFunc(self._id, self._editor_name)
	end)
end