core:import("CoreMissionScriptElement")
core:import("CoreClass")

MissionScriptElement = MissionScriptElement or class(CoreMissionScriptElement.MissionScriptElement)

if MissionScriptElement and Global.game_settings and Global.game_settings.level_id and Global.game_settings.level_id == "kenaz" then
	_G.ArchivesHelperGGC = _G.ArchivesHelperGGC or {}
	local ArchivesHelperGGC = _G.ArchivesHelperGGC
	
	local function ArchivesHelperGGC_WPAttachedFunc(id, name)
		if managers.job:current_level_id() == "kenaz" then
			if id == 140539 and name == "output_archives_found" then
				ArchivesHelperGGC:WPON()
			elseif id == 100034 and name == "blueprints_found_link" then
				ArchivesHelperGGC:WPOFF()
			end
		end      
		return
	end
	
	Hooks:PostHook(MissionScriptElement, "on_executed", "ArchivesHelperGGC_WPAttached1", function(self)
		ArchivesHelperGGC_WPAttachedFunc(self._id, self._editor_name)
	end)

	Hooks:PostHook(MissionScriptElement, "client_on_executed", "ArchivesHelperGGC_WPAttached2", function(self)
		ArchivesHelperGGC_WPAttachedFunc(self._id, self._editor_name)
	end)
end