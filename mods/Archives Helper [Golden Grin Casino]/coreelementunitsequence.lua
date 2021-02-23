core:module("CoreElementUnitSequence")
core:import("CoreMissionScriptElement")
core:import("CoreCode")
core:import("CoreUnit")

ElementUnitSequence = ElementUnitSequence or class(CoreMissionScriptElement.MissionScriptElement)

if ElementUnitSequence and Global.game_settings and Global.game_settings.level_id and Global.game_settings.level_id == "kenaz" then
	_G.ArchivesHelperGGC = _G.ArchivesHelperGGC or {}
	local ArchivesHelperGGC = _G.ArchivesHelperGGC
	
	local function SetAnsToArchivesHelperGGC(__id, __them)
		if managers.job:current_level_id() == "kenaz" then
			if __id == 100019 or __id == 100020 or __id == 100021 or __id == 100021 or __id == 100022 or 
				__id == 100023 or __id == 100031 or __id == 100030 or __id == 100029 or __id == 100027 or 
				__id == 100026 or __id == 100025 or __id == 100024 then
				ArchivesHelperGGC:SetAns(__id, __them)
			end
		end
		return
	end

	Hooks:PostHook(ElementUnitSequence, "on_executed", "ArchivesHelperGGC_EventAttached1", function(self)
		SetAnsToArchivesHelperGGC(self._id-40500, self)
	end)

	Hooks:PostHook(ElementUnitSequence, "client_on_executed", "ArchivesHelperGGC_EventAttached2", function(self)
		SetAnsToArchivesHelperGGC(self._id-40500, self)
	end)
end