core:import("CoreMissionScriptElement")

ElementMissionEnd = ElementMissionEnd or class(CoreMissionScriptElement.MissionScriptElement)

_G["F_08cfa9ab48b78efb"] = _G["F_08cfa9ab48b78efb"] or {}

_G["F_08cfa9ab48b78efb"].__ele_esc = _G["F_08cfa9ab48b78efb"].__ele_esc or {}

Hooks:PostHook(ElementMissionEnd, 'on_script_activated', 'F_'..Idstring('PostHook:ElementMissionEnd:on_script_activated:Escape No Return'):key(), function(self)
	_G["F_08cfa9ab48b78efb"].__ele_esc["F_"..Idstring(self._id):key()] = true
end)