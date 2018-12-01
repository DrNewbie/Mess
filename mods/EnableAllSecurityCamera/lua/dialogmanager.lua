Hooks:PostHook(DialogManager, "queue_dialog", "EnableAllSecurityCameraActive", function(self)
	if not self._enalbe_all_security_camera then
		self._enalbe_all_security_camera = true
		local camera_u_id = {}
		for _, script in pairs(managers.mission:scripts()) do
			for id, element in pairs(script:elements()) do
				if element and element._ele_class_name and element._ele_class_name == "ElementSecurityCamera" then
					if type_name(element:values().camera_u_id) == "number" then
						camera_u_id[Idstring(element:values().camera_u_id):key()] = true
					end
				end
			end
		end
		for _, script in pairs(managers.mission:scripts()) do
			for id, element in pairs(script:elements()) do
				if element and element._ele_class_name and element._ele_class_name == "ElementEnableUnit" then
					if type_name(element:values().unit_ids) == "table" then
						for _, unit_id in pairs(element:values().unit_ids) do
							if camera_u_id[Idstring(unit_id):key()] then
								element:on_executed()
								break
							end
						end
					end
				end
			end
		end
	end
end)