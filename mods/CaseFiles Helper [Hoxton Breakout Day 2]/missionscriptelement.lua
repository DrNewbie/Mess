core:import("CoreMissionScriptElement")
core:import("CoreClass")

MissionScriptElement = MissionScriptElement or class(CoreMissionScriptElement.MissionScriptElement)

if MissionScriptElement and Global.game_settings and Global.game_settings.level_id and Global.game_settings.level_id == "hox_2" then
	_G.CaseFilesHelper = _G.CaseFilesHelper or {}
	local CaseFilesHelper = _G.CaseFilesHelper
	
	local function CaseFilesHelper_WPAttachedFunc(id, name)
		if managers.job:current_level_id() == "hox_2" then
			if id == 104781 and name == "enter_archives_trigger" then
				CaseFilesHelper:WPON()
			elseif id == 103917 and name == "found_intelligence" then
				CaseFilesHelper:WPOFF()
			end
		end
		return
	end
	
	Hooks:PostHook(MissionScriptElement, "on_executed", "CaseFilesHelper_WPAttached1", function(self)
		CaseFilesHelper_WPAttachedFunc(self._id, self._editor_name)
	end)

	Hooks:PostHook(MissionScriptElement, "client_on_executed", "CaseFilesHelper_WPAttached2", function(self)
		CaseFilesHelper_WPAttachedFunc(self._id, self._editor_name)
	end)
end