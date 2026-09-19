local ThisModPath = ModPath

core:import("CoreElementArea")
core:import("CoreClass")

local ThisModPathdIds = Idstring(ThisModPath):key()
local __Name = function(__id)
	return "UPF_"..Idstring(tostring(__id).."::"..ThisModPathdIds):key()
end

ElementAreaTrigger = ElementAreaTrigger or class(CoreElementArea.ElementAreaTrigger)

Hooks:PostHook(ElementAreaTrigger, "init", __Name("init"), function(self, ...)
	if Global.load_level == true and managers.job:current_level_id() == "framing_frame_1" then 
		if self._id == 104285 and self._editor_name == "trigger_area_016" then
			self._values.amount = "all"
			self._values.trigger_times = 999999
		end
	end
end)