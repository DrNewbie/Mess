core:module("CoreWorldDefinition")
core:import("CoreUnit")
core:import("CoreMath")
core:import("CoreEditorUtils")
core:import("CoreEngineAccess")
WorldDefinition = WorldDefinition or class()

if Global.load_level == true and Global.level_data.level_id == "bph" then
	local old_make_unit = WorldDefinition.make_unit
	function WorldDefinition:make_unit(data, ...)
		if Global.level_data.level_id == "bph" and tostring(data.continent) == "lights2" then			
			if tostring(data.name):find("dlc") or data.projection_textures then
				return nil
			end
		end
		return old_make_unit(self, data, ...)
	end
end