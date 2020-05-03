core:import("CoreMissionScriptElement")
core:import("CoreClass")

MissionScriptElement = MissionScriptElement or class(CoreMissionScriptElement.MissionScriptElement)

local __ids_key = Idstring("PostHook:MissionScriptElement:on_executed:Slot Machine Buff"):key()

if Global.level_data and Global.level_data.level_id and (Global.level_data.level_id == "kenaz" or Global.level_data.level_id == "skm_cas") then
	Hooks:PostHook(MissionScriptElement, "on_executed", "F_"..__ids_key, function(self)
		if not self["K_"..__ids_key] and self._editor_name:find("show_winning_chips_") and self._values and type(self._values.on_executed) == "table" and (Global.level_data.level_id == "kenaz" or Global.level_data.level_id == "skm_cas") then
			self["K_"..__ids_key] = true
			for _, params in pairs(self._values.on_executed) do
				if type(params) == "table" and params.id then
					local __element = self:get_mission_element(params.id)
					if __element then
						if __element._editor_name:find("show_chips_") and __element._values and type(__element._values.trigger_list) == "table" then
							for _, __trigger in pairs(__element._values.trigger_list) do
								if type(__trigger) == "table" and __trigger.notify_unit_id and __trigger.notify_unit_sequence and __trigger.notify_unit_sequence == "state_interaction_enabled" then
									local __unit = managers.worlddefinition:get_unit_on_load(__trigger.notify_unit_id)
									if __unit and alive(__unit) then
										DelayedCalls:Add("D_"..Idstring(self._editor_name..":managers.player:hold_server_drop_carry:Slot Machine Cheat Buff"):key(), 5, function()
											managers.player:server_drop_carry("cloaker_gold", 1, true, false, 1, __unit:position(), __unit:rotation(), Vector3(0, 0, 0), 0, nil, nil)
										end)
									end
								end
							end
						end
					end
				end
			end
		end
	end)
end