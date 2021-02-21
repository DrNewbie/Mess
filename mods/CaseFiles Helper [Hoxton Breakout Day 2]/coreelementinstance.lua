core:module("CoreElementInstance")
core:import("CoreMissionScriptElement")

ElementInstanceInputEvent = ElementInstanceInputEvent or class(CoreMissionScriptElement.MissionScriptElement)

if ElementInstanceInputEvent and Global.game_settings and Global.game_settings.level_id and Global.game_settings.level_id == "hox_2" then
	_G.CaseFilesHelper = _G.CaseFilesHelper or {}
	local CaseFilesHelper = _G.CaseFilesHelper
	
	local function SetAnsToCaseFilesHelper(id)
		if managers.job:current_level_id() == "hox_2" then
			if id == 103948 then
				CaseFilesHelper:SetAns(Vector3(375, 3350, -800))
			elseif id == 103949 then
				CaseFilesHelper:SetAns(Vector3(375, 3050, -800))
			elseif id == 103950 then
				CaseFilesHelper:SetAns(Vector3(375, 2450, -800))
			elseif id == 103951 then
				CaseFilesHelper:SetAns(Vector3(75, 335, -800))
			elseif id == 103952 then
				CaseFilesHelper:SetAns(Vector3(75, 3050, -800))
			elseif id == 103953 then
				CaseFilesHelper:SetAns(Vector3(75, 2450, -800))
			elseif id == 103954 then
				CaseFilesHelper:SetAns(Vector3(-225, 3050, -800))
			elseif id == 103955 then
				CaseFilesHelper:SetAns(Vector3(-225, 3050, -800))
			elseif id == 103956 then
				CaseFilesHelper:SetAns(Vector3(-225, 2450, -800))
			end
		end
		return
	end

	Hooks:PostHook(ElementInstanceInputEvent, "on_executed", "CaseFilesHelper_EventAttached1", function(self)
		SetAnsToCaseFilesHelper(self._id)
	end)

	Hooks:PostHook(ElementInstanceInputEvent, "client_on_executed", "CaseFilesHelper_EventAttached2", function(self)
		SetAnsToCaseFilesHelper(self._id)
	end)
end