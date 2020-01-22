local old_func = HostNetworkSession.send_to_peers_synched
local match_name = {
	["run_mission_element"] = true,
	["run_mission_element_no_instigator"] = true
}
local dialog_ids = {
	{
		["pln_rt1_20"] = "mu",
		["pln_rt1_22"] = "cs",
		["pln_rt1_24"] = "hcl"
	},
	{
		["pln_rat_stage1_20"] = "mu",
		["pln_rat_stage1_22"] = "cs",
		["pln_rat_stage1_24"] = "hcl"
	},
	{
		["Play_loc_mex_cook_03"] = "mu",
		["Play_loc_mex_cook_04"] = "cs",
		["Play_loc_mex_cook_05"] = "hcl"
	}
}
local _possible_ids = {
	_cids = {},
	_init = nil,
	_pids = {}
}

function HostNetworkSession:send_to_peers_synched(v1, v2, ...)
	if managers.mission and type(v1) == "string" and match_name[v1] then
		local _dialogue_id
		local _v2_ids = Idstring(v2)
		if not _possible_ids._cids[_v2_ids] then
			for _, script in pairs(managers.mission:scripts()) do
				for _id, element in pairs(script:elements()) do
					if element and element._values and element._values.dialogue and _id == v2 then
						_dialogue_id = element._values.dialogue
						if dialog_ids[1][_dialogue_id] or dialog_ids[2][_dialogue_id] or dialog_ids[3][_dialogue_id] then
							_possible_ids._cids[_v2_ids] = 1
						else
							_possible_ids._cids[_v2_ids] = -1
						end
						break
					end
				end
			end
		end
		if type(_possible_ids._cids[_v2_ids]) == "number" and _possible_ids._cids[_v2_ids] == 1 then
			if not _possible_ids._init then
				_possible_ids._init = true
				for _, script in pairs(managers.mission:scripts()) do
					for _id, element in pairs(script:elements()) do
						if element and element._values and element._values.dialogue then
							_dialogue_id = element._values.dialogue
							if dialog_ids[1][_dialogue_id] or dialog_ids[2][_dialogue_id] or dialog_ids[3][_dialogue_id] then
								_possible_ids._pids[_dialogue_id] = _id
							end
						end
					end
				end
			end
			local _new_v2 = table.random_key(_possible_ids._pids)
			if _new_v2 then
				v2 = _possible_ids._pids[_new_v2]
				for peer_id, peer in pairs(self._peers) do
					peer:send_queued_sync(v1, v2, ...)
				end
				return
			end
		end
	end
	old_func(self, v1, v2, ...)
end