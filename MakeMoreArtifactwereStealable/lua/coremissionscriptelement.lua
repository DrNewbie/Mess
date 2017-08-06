core:module("CoreMissionScriptElement")
core:import("CoreXml")
core:import("CoreCode")
core:import("CoreClass")

if not Global.game_settings or not Global.game_settings.level_id or not Global.game_settings.level_id == "mus" then
	return
end

local _f_MissionScriptElement_on_executed = MissionScriptElement.on_executed

function MissionScriptElement:on_executed(instigator, alternative, skip_execute_on_executed)
	local _id = tostring(self._id)
	if Global.game_settings then
		if Global.game_settings.level_id == "mus" then
			if _id == "102527" then
				local element
				local _id_forxed_list = {
					101195, 101196, 101197, 101198, 101199, 101200, 
					101201, 101209, 101211, 101213, 101215, 101217, 102162, 102164, 
					102165, 102166, 102167, 102168, 102169, 102170, 102171, 
					102480, 102497, 102498, 102499, 102500, 102501, 102502, 102503, 102504, 102505, 102506, 102507, 102508, 
					102496, 102509, 102510, 102511, 102512, 102513, 102514, 102515, 102516, 102517, 102518, 
					100257, 102560, 102561, 102562, 102563, 102564, 102565, 102566, 102567, 102568, 102569, 102570, 102571, 102572, 102573
				}
				for _, _id_foced in pairs(_id_forxed_list) do
					element = self:get_mission_element(_id_foced)
					if element then
						self._mission_script:add(callback(element, element, "on_executed", instigator), 0.1, 1)
						managers.network:session():send_to_peers_synched("run_mission_element", _id_foced, instigator, 0)
					end
				end
				return
			end
		end
	end
	_f_MissionScriptElement_on_executed(self, instigator, alternative, skip_execute_on_executed)
end