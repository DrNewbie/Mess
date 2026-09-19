core:import("CoreElementArea")
core:import("CoreClass")

ElementAreaTrigger = ElementAreaTrigger or class(CoreElementArea.ElementAreaTrigger)

_G["F_08cfa9ab48b78efb"] = _G["F_08cfa9ab48b78efb"] or {}

_G["F_08cfa9ab48b78efb"].__ele_esc = _G["F_08cfa9ab48b78efb"].__ele_esc or {}

Hooks:PostHook(ElementAreaTrigger, 'project_instigators', 'F_'..Idstring('PostHook:ElementAreaTrigger:project_instigators:Escape No Return'):key(), function(self)
	if type(self._values.on_executed) == "table" then
		for _, __para in pairs(self._values.on_executed) do
			if type(__para) == "table" and type(__para.id) == "number" then
				if _G["F_08cfa9ab48b78efb"].__ele_esc["F_"..Idstring(__para.id):key()] then
					if not _G["F_08cfa9ab48b78efb"].__ele_bool or _G["F_08cfa9ab48b78efb"].__ele_bool ~= __para.id then
						_G["F_08cfa9ab48b78efb"].__ele_bool = __para.id
						if not managers.groupai:state()._point_of_no_return_timer or managers.groupai:state()._point_of_no_return_timer > 3*60 then
							managers.groupai:state():set_point_of_no_return_timer(3*60, 0)
						end
					end
				end
			end
		end
	end
end)