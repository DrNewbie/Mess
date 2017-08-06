core:module("CoreWorldDefinition")
core:import("CoreUnit")
core:import("CoreMath")
core:import("CoreEditorUtils")
core:import("CoreEngineAccess")
WorldDefinition = WorldDefinition or class()

if Network:is_client() then
	return
end

if not Global.game_settings or Global.game_settings.level_id ~= "red2" then
	return
end

local HAHA_WorldDefinition_make_unit = WorldDefinition.make_unit

function WorldDefinition:make_unit(data, ...)
	if tostring(data.name_id):find('gen_pku_gold') and tostring(data.name):find('gen_pku_gold') then
		data.name = "units/payday2/pickups/gen_pku_money_multi/gen_pku_money_multi"
	end
	return HAHA_WorldDefinition_make_unit(self, data, ...)
end