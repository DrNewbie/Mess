core:module("CoreWorldDefinition")
core:import("CoreUnit")
core:import("CoreMath")
core:import("CoreEditorUtils")
core:import("CoreEngineAccess")

WorldDefinition = WorldDefinition or class()

local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local hook2 = "F_"..Idstring("hook2::"..ThisModIds):key()
local bool2 = "F_"..Idstring("bool2::"..ThisModIds):key()

if Network and Network:is_client() then

else
	if not Global.game_settings or not Global.game_settings.level_id or Global.game_settings.level_id ~= "mus" then

	else
		Hooks:PostHook(WorldDefinition, "assign_unit_data", hook2, function(self, unit, data)
			if not unit or not Global.game_settings or not Global.game_settings.level_id or Global.game_settings.level_id ~= "mus" then

			else
				if type(data) == "table" and not data[bool2] then
					if unit:unit_data().mesh_variation == "state_interact_disable" then
						data[bool2] = true
						unit:unit_data().mesh_variation = "state_interact_enable"
					elseif unit:unit_data().mesh_variation == "disable_interaction" then
						data[bool2] = true
						unit:unit_data().mesh_variation = "enable_interaction"
					end
					if data[bool2] then
						managers.sequence:run_sequence_simple2(unit:unit_data().mesh_variation, "change_state", unit)
					end
				end
			end
		end)
	end
end