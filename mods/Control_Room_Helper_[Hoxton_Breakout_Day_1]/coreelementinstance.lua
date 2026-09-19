core:module("CoreElementInstance")
core:import("CoreMissionScriptElement")

ElementInstanceInputEvent = ElementInstanceInputEvent or class(CoreMissionScriptElement.MissionScriptElement)

if ElementInstanceInputEvent and Global.game_settings and Global.game_settings.level_id and Global.game_settings.level_id == "hox_1" then
	_G.ControlRoomHelper = _G.ControlRoomHelper or {}
	local ControlRoomHelper = _G.ControlRoomHelper
	
	local function SetAnsToControlRoomHelper(id)
		if id == 101520 then
			ControlRoomHelper:SetAns(Vector3(9600, 5700, -2800))
		elseif id == 101523 then
			ControlRoomHelper:SetAns(Vector3(12825, 8300, -2800))
		elseif id == 101524 then
			ControlRoomHelper:SetAns(Vector3(9600, 8500, -2700))
		elseif id == 101525 then
			ControlRoomHelper:SetAns(Vector3(11200, 8500, -2500))
		elseif id == 101527 then
			ControlRoomHelper:SetAns(Vector3(8375, 5900, -2400))
		elseif id == 101528 then
			ControlRoomHelper:SetAns(Vector3(9600, 8500, -2300))
		elseif id == 101529 then
			ControlRoomHelper:SetAns(Vector3(11200, 8500, -2100))
		elseif id == 101531 then
			ControlRoomHelper:SetAns(Vector3(8600, 8175, -2000))
		elseif id == 101806 then
			ControlRoomHelper:SetAns(Vector3(10700, 6150, -2000))
		elseif id == 101807 then
			ControlRoomHelper:SetAns(Vector3(12400, 4300, -2400))
		end
	end

	Hooks:PostHook(ElementInstanceInputEvent, "on_executed", "ControlRoomHelper_EventAttached1", function(self)
		SetAnsToControlRoomHelper(self._id)
	end)

	Hooks:PostHook(ElementInstanceInputEvent, "client_on_executed", "ControlRoomHelper_EventAttached2", function(self)
		SetAnsToControlRoomHelper(self._id)
	end)
end