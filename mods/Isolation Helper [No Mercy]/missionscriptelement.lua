core:import("CoreMissionScriptElement")
core:import("CoreClass")

MissionScriptElement = MissionScriptElement or class(CoreMissionScriptElement.MissionScriptElement)

if MissionScriptElement and Global.game_settings and Global.game_settings.level_id and Global.game_settings.level_id == "nmh" then
	_G.IsolationRoomHelper = _G.IsolationRoomHelper or {}
	local IsolationRoomHelper = _G.IsolationRoomHelper
	
	local function IsolationRoomHelper_WPAttachedFunc(id, name)
		if id == 102309 and name == "chooseRandomRoom" then
			IsolationRoomHelper:WPON()
		elseif (id == 104516 and name == "area_player_by_correct_room_A") or 
			 (id == 104515 and name == "area_player_by_correct_room_B") or 
			 (id == 104512 and name == "area_player_by_correct_room_C") then
			IsolationRoomHelper:WPOFF()
		elseif id == 102310 and name == "room1" then
			IsolationRoomHelper:SetAns(Vector3(-1349, 2086, 128.571))
			IsolationRoomHelper:WPON()
		elseif id == 102311 and name == "room2" then
			IsolationRoomHelper:SetAns(Vector3(-1016, 2028, 129.044))
			IsolationRoomHelper:WPON()
		elseif id == 102312 and name == "room3" then
			IsolationRoomHelper:SetAns(Vector3(-1016, 2556, 120.12))
			IsolationRoomHelper:WPON()
		end
		return
	end
	
	Hooks:PostHook(MissionScriptElement, "on_executed", "IsolationRoomHelper_WPAttached1", function(self)
		IsolationRoomHelper_WPAttachedFunc(self._id, self._editor_name)
	end)

	Hooks:PostHook(MissionScriptElement, "client_on_executed", "IsolationRoomHelper_WPAttached2", function(self)
		IsolationRoomHelper_WPAttachedFunc(self._id, self._editor_name)
	end)
end