Hooks:PostHook(PlayerStandard, "init", "LoadConcussionResource", function(self)
	local data = tweak_data.blackmarket.projectiles["concussion"]
	if data then
		local unit_name = Idstring(not Network:is_server() and data.local_unit or data.unit)
		if not managers.dyn_resource:is_resource_ready(Idstring("unit"), unit_name, managers.dyn_resource.DYN_RESOURCES_PACKAGE) then
			managers.dyn_resource:load(Idstring("unit"), unit_name, managers.dyn_resource.DYN_RESOURCES_PACKAGE)
		end
	end	
end)