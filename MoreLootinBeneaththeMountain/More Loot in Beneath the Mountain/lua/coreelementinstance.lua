core:module("CoreElementInstance")
core:import("CoreMissionScriptElement")
ElementInstanceInput = ElementInstanceInput or class(CoreMissionScriptElement.MissionScriptElement)

if not Global.game_settings or not Global.game_settings.level_id or not Global.game_settings.level_id == "pbr" then
	return
end

local _MMM_ElementInstanceInputEvent_on_executed = ElementInstanceInputEvent.on_executed

local _run_this_once = false

function ElementInstanceInputEvent:on_executed(instigator)
	if Global.game_settings then
		if Global.game_settings.level_id == "pbr" then
			local _id = "id_" .. tostring(self._id)
			local _id_attached = {
				id_101035 = true, id_101041 = true, id_101036 = true, id_101692 = true,
				id_101039 = true, id_101038 = true, id_101037 = true, id_101693 = true,
				id_101043 = true, id_101042 = true, id_101040 = true, id_101694 = true,
				id_101046 = true, id_101045 = true, id_101044 = true, id_101695 = true,
				id_101049 = true, id_101048 = true, id_101047 = true, id_101696 = true,
				id_101052 = true, id_101051 = true, id_101050 = true, id_101697 = true
			}
			if _id_attached[_id] then
				if not _run_this_once then
					_run_this_once = true
					local element
					local _active = {
						{instance = "pbr_mountain_vault_001", event = "set_content_art"},
						{instance = "pbr_mountain_vault_002", event = "set_content_art"},
						{instance = "pbr_mountain_vault_003", event = "set_content_weapon"},
						{instance = "pbr_mountain_vault_004", event = "set_content_weapon"},
						{instance = "pbr_mountain_vault_005", event = "set_content_server"},
						{instance = "pbr_mountain_vault_006", event = "set_content_server"},
						{instance = "pbr_mountain_vault_gate001", event = "set_gate_vault"},
						{instance = "pbr_mountain_vault_gate002", event = "set_gate_vault"},
						{instance = "pbr_mountain_vault_gate003", event = "set_gate_vault"},
						{instance = "pbr_mountain_vault_gate004", event = "set_gate_vault"},
						{instance = "pbr_mountain_vault_gate005", event = "set_gate_vault"},
						{instance = "pbr_mountain_vault_gate006", event = "set_gate_vault"},
					}
					for _, data in ipairs(_active) do
						local input_elements = managers.world_instance:get_registered_input_elements(data.instance, data.event)
						if input_elements then
							for _, element in ipairs(input_elements) do
								element:on_executed(instigator)
							end
						end
					end
					for i = 1, 25 do
						local _idx = "" .. i
						if i < 10 then
							_idx = "0" .. _idx
						end
						_idx = "pbr_mountain_loot_crate_0" .. _idx
						local input_elements = managers.world_instance:get_registered_input_elements(_idx, "set_loot_crate")
						if input_elements then
							for _, element in ipairs(input_elements) do
								element:on_executed(instigator)
							end
						end
					end
				end
				return
			end
		end
	end
	_MMM_ElementInstanceInputEvent_on_executed(self, instigator)
end