if Network and not Network:is_server() then
	return
end

_G.Sound_Moving = _G.Sound_Moving or {}

Sound_Moving.Data = {
	ply = nil,
	delay = {}
}

function Sound_Moving:Is_ply_OK()
	if not managers.groupai:state():whisper_mode() or not managers.navigation or not managers.navigation:is_data_ready() then
		return
	end
	if not Sound_Moving.Data or not Sound_Moving.Data.ply or not Sound_Moving.Data.ply._unit or not alive(Sound_Moving.Data.ply._unit) then
		return
	end
	return true
end

function Sound_Moving:Create_Point(sound_source_pos)
	if not self:Is_ply_OK() then
		return
	end
	local ply = Sound_Moving.Data.ply
	if not u_key then
		u_key = tostring(ply._unit:key())
	end
	local __now_t = TimerManager:game():time()
	if self.__dt and self.__dt > __now_t then
		return
	end
	self.__dt = __now_t + 3
	local __units = World:find_units("sphere", sound_source_pos, 900, managers.slot:get_mask("enemies"))
	for _, candidate_unit in pairs(__units) do
		if candidate_unit:movement() and candidate_unit:brain() and (not candidate_unit:brain().__who_there_dt or __now_t > candidate_unit:brain().__who_there_dt) then
			local candidate_listen_pos = candidate_unit:movement():m_head_pos()
			local ray = ply._unit:raycast("ray", candidate_listen_pos, sound_source_pos, "slot_mask", managers.slot:get_mask("AI_visibility"), "ray_type", "ai_vision", "report")
			if ray then
				local my_dis = mvector3.distance(candidate_listen_pos, sound_source_pos)
				if my_dis <= 900 then
					local cop = candidate_unit:base()
					candidate_unit:brain().__who_there_dt = __now_t + 60
					local _nav_tracker = ply._unit:movement():nav_tracker()
					local investigate_nav_seg = _nav_tracker:nav_segment()
					local investigate_area = managers.groupai:state():get_area_from_nav_seg_id(investigate_nav_seg)
					local old_objective = {
						type = "free",
						stance = "ntl",
						haste = "walk",
						scan = true,
						interrupt_dis = -1,
						attitude = "engage",
						path_style = "coarse_complete",
						followup_objective = candidate_unit:brain():objective(),
						pos = candidate_unit:movement():m_pos(),
						rot = Rotation(),
						nav_seg = investigate_nav_seg,
						area = investigate_area
					}
					local go_to_search_pos = {
						stance = "ntl",
						type = "free",
						action_duration = 5,
						haste = "walk",
						scan = true,
						interrupt_dis = -1,
						attitude = "engage",
						pos = sound_source_pos,
						nav_seg = investigate_nav_seg,
						area = investigate_area,
						followup_objective = old_objective
					}
					candidate_unit:brain():set_objective(go_to_search_pos)
					if candidate_unit:contour() then
						candidate_unit:contour():add("medic_heal", true)
						candidate_unit:contour():flash("medic_heal", 0.2)
					end
					break
				end
			end
		end
	end
end

Hooks:PostHook(ProjectileBase, "clbk_impact", "F_"..Idstring("PostHook:ProjectileBase:clbk_impact:Create_Point"):key(), function(self, tag, unit, body, other_unit, other_body, position)
	local playerss = managers.groupai:state():all_player_criminals()
	if type(playerss) == "table" then
		local cc = playerss[table.random_key(playerss)]
		if cc and cc.unit and alive(cc.unit) then
			Sound_Moving.Data.ply = cc.unit:base()
			Sound_Moving:Create_Point(position)
		end
	end
end)

