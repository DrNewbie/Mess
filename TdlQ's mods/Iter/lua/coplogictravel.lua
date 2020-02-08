local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

if not Iter.settings.streamline_path then
	return
end

local fs_settings = FullSpeedSwarm and FullSpeedSwarm.final_settings or {}

local itr_original_coplogictravel_enter = CopLogicTravel.enter
function CopLogicTravel.enter(data, ...)
	itr_original_coplogictravel_enter(data, ...)

	if data.is_converted or fs_settings.iter_chase then
		data.internal_data.path_ahead = true
	end

	local my_data = data.internal_data
	if my_data.path_safely and managers.groupai:state():whisper_mode() then
		my_data.path_safely = nil
	end
end

function CopLogicTravel.itr_insert_wait_step(data, my_data, navlink)
	local coarse_path = my_data.coarse_path
	local next_step_index = my_data.coarse_path_index + 1
	local seg_id = coarse_path[my_data.coarse_path_index][1]
	if next_step_index <= 2 or seg_id ~= coarse_path[next_step_index - 2][1] then
		local start_pos = navlink:script_data().element:value('position')
		local cover = managers.navigation:find_cover_in_nav_seg_3({[seg_id] = true}, 300, start_pos)
		local wait_pos = cover and cover[1] or CopLogicTravel._get_pos_on_wall(start_pos, 200)
		if wait_pos then
			data.pathing_results = nil
			table.insert(coarse_path, next_step_index, { seg_id, wait_pos })
			local prio = data.logic.get_pathing_prio(data)
			local nav_segs = CopLogicTravel._get_allowed_travel_nav_segs(data, my_data, wait_pos)
			data.brain:search_for_path(my_data.advance_path_search_id, wait_pos, prio, nil, nav_segs)
		else
			return
		end
	else
		my_data.coarse_path_index = my_data.coarse_path_index - 1
		my_data.processing_advance_path = nil
	end
	return true
end

local itr_original_coplogictravel_updpathing = CopLogicTravel._upd_pathing
function CopLogicTravel._upd_pathing(data, my_data)
	local pathing_results = data.pathing_results
	if pathing_results then
		if my_data.processing_advance_path then
			local path = pathing_results[my_data.advance_path_search_id]
			if path == 'failed' then
				local something_went_wrong
				local coarse_path = my_data.coarse_path
				local next_step_index = my_data.coarse_path_index + 1
				local navlink = coarse_path and coarse_path[next_step_index] and coarse_path[next_step_index][3]

				if not navlink or navlink.x then
					local next_pos = coarse_path[next_step_index] and coarse_path[next_step_index][2]
					if next_pos then
						local prio = data.logic.get_pathing_prio(data)
						data.pathing_results[my_data.advance_path_search_id] = nil
						data.brain:search_for_path(my_data.advance_path_search_id, next_pos, prio, nil, nil)
					else
						something_went_wrong = true
					end

				elseif not navlink:alive() or navlink:is_obstructed() then
					something_went_wrong = true

				elseif not CopLogicTravel.itr_insert_wait_step(data, my_data, navlink) then
					something_went_wrong = true
				end

				if not something_went_wrong then
					return
				end
			end
		end

		if my_data.processing_coarse_path then
			local path = pathing_results[my_data.coarse_path_search_id]
			if path == 'failed' and not my_data.path_safely then
				local current_SO_element = data.objective and data.objective.followup_SO
				if current_SO_element then
					local unit = data.unit
					local so_element = current_SO_element:choose_followup_SO(unit)
					if so_element then
						local new_objective = so_element:get_objective(unit)
						if new_objective then
							my_data.processing_coarse_path = nil
							unit:brain():set_objective(new_objective)
							return
						end
					end
				end
			end
		end
	end

	itr_original_coplogictravel_updpathing(data, my_data)
end

local itr_original_coplogictravel_getexactmovepos = CopLogicTravel._get_exact_move_pos
function CopLogicTravel._get_exact_move_pos(data, nav_index)
	local my_data = data.internal_data
	local coarse_path = my_data.coarse_path
	local nr = #coarse_path

	if nr > 2 and nav_index == 2 and my_data.itr_direct_to_pos then
		if my_data.moving_to_cover then
			managers.navigation:release_cover(my_data.moving_to_cover[1])
			my_data.moving_to_cover = nil
		end

		local nav_segs = {}
		for i = 1, nr do
			nav_segs[i] = coarse_path[i][1]
		end
		my_data.itr_nav_segs = nav_segs

		my_data.coarse_path = {
			coarse_path[1],
			coarse_path[nr]
		}

		return my_data.itr_direct_to_pos
	end

	if nav_index < nr then
		if data.is_converted or data.team and data.team.id == 'criminal1' then
			if my_data.moving_to_cover then
				managers.navigation:release_cover(my_data.moving_to_cover[1])
				my_data.moving_to_cover = nil
			end
			return coarse_path[nav_index][2]

		elseif data.objective and data.objective.type == 'phalanx' then
			return coarse_path[nav_index][2]
		end
	end

	return itr_original_coplogictravel_getexactmovepos(data, nav_index)
end

local itr_original_coplogictravel_getallowedtravelnavsegs = CopLogicTravel._get_allowed_travel_nav_segs
function CopLogicTravel._get_allowed_travel_nav_segs(data, my_data, to_pos)
	local itr_nav_segs = my_data.itr_nav_segs
	if itr_nav_segs then
		my_data.itr_nav_segs = nil
		return itr_nav_segs
	end

	return itr_original_coplogictravel_getallowedtravelnavsegs(data, my_data, to_pos)
end

local function update_destination(my_data, follow_unit_nav_seg, pos_rsrv_id)
	local to_pos
	if my_data.moving_to_cover then
		managers.navigation:release_cover(my_data.moving_to_cover[1])
		my_data.moving_to_cover = nil
	end
	local cover = managers.navigation:find_cover_in_nav_seg_1(follow_unit_nav_seg)
	if cover then
		managers.navigation:reserve_cover(cover, pos_rsrv_id)
		my_data.moving_to_cover = {cover}
		to_pos = cover[1]
	else
		to_pos = managers.navigation:find_random_position_in_segment(follow_unit_nav_seg)
		to_pos = CopLogicTravel._get_pos_on_wall(to_pos)
	end
	return to_pos
end

local table_remove = table.remove
function CopLogicTravel.itr_simplify_coarse_path(data, my_data)
	local coarse_path = my_data.coarse_path
	local coarse_path_nr = #coarse_path
	local original_coarse_path_nr = coarse_path_nr

	-- A > B > A => A
	local must_cancel_next_path
	local i = my_data.coarse_path_index
	while i + 1 < coarse_path_nr do
		local current = coarse_path[i][1]
		for j = coarse_path_nr - 1, i + 1, -1 do
			if coarse_path[j][1] == current then
				must_cancel_next_path = must_cancel_next_path or i <= my_data.coarse_path_index + 1
				local nr = j - i
				for k = 1, nr do
					table_remove(coarse_path, i + 1)
				end
				coarse_path_nr = coarse_path_nr - nr
				break
			end
		end
		i = i + 1
	end

	-- A > B > C & A neighbour C => A > C
	local path_backup
	local nav = managers.navigation
	i = my_data.coarse_path_index
	while i + 1 < coarse_path_nr do
		local neighbours = nav:get_nav_seg_neighbours(coarse_path[i][1])
		for j = coarse_path_nr - 1, i + 2, -1 do
			if neighbours[coarse_path[j][1]] then
				must_cancel_next_path = must_cancel_next_path or i <= my_data.coarse_path_index + 1
				path_backup = path_backup or deep_clone(coarse_path)
				local nr = j - i
				for k = 1, nr do
					table_remove(coarse_path, i + 1)
				end
				coarse_path_nr = coarse_path_nr - nr
				break
			end
		end
		i = i + 1
	end

	if must_cancel_next_path then
		my_data.processing_advance_path = nil
		if data.pathing_results then
			data.pathing_results = nil
		else
			data.brain:cancel_all_pathing_searches()
		end
		if my_data.path_ahead and my_data.advancing then
			my_data.advancing:itr_delete_path_ahead()
		end
	end

	if path_backup then
		table_remove(coarse_path, coarse_path_nr)
		if not nav:itr_streamline(coarse_path, data.brain._SO_access) then
			my_data.coarse_path = path_backup
		end
	end

	return original_coarse_path_nr ~= coarse_path_nr
end

function CopLogicTravel._chk_stop_for_follow_unit(data, my_data)
	local objective = data.objective
	if objective.type ~= 'follow' or data.unit:movement():chk_action_forbidden('walk') or data.unit:anim_data().act_idle then
		return
	end
	if not my_data.coarse_path_index then
		return
	end

	local follow_unit = data.objective.follow_unit
	if not alive(follow_unit) then
		return
	end

	local follow_unit_nav_seg = follow_unit:movement():nav_tracker():nav_segment()
	local next_coarse_path_index = my_data.coarse_path_index + 1
	local coarse_path = my_data.coarse_path
	local my_next_seg = coarse_path[next_coarse_path_index] and coarse_path[next_coarse_path_index][1]
	local coarse_path_nr = #coarse_path
	local my_nav_seg = data.unit:movement():nav_tracker():nav_segment()

	if follow_unit_nav_seg == my_nav_seg and follow_unit_nav_seg ~= my_next_seg then
		while coarse_path[next_coarse_path_index] do
			table_remove(coarse_path, next_coarse_path_index)
		end
		coarse_path[next_coarse_path_index] = {
			[1] = follow_unit_nav_seg,
			[2] = update_destination(my_data, follow_unit_nav_seg, data.pos_rsrv_id)
		}
		data.logic.on_new_objective(data)

	elseif data.itr_follow_unit_nav_seg and data.itr_follow_unit_nav_seg ~= follow_unit_nav_seg and coarse_path[coarse_path_nr][1] ~= follow_unit_nav_seg then
		local pos = managers.navigation:itr_get_door_between(data.itr_follow_unit_nav_seg, follow_unit_nav_seg, follow_unit:position())
		if pos then
			coarse_path[coarse_path_nr][1] = follow_unit_nav_seg
			coarse_path[coarse_path_nr][2] = pos

			coarse_path[coarse_path_nr + 1] = {
				[1] = follow_unit_nav_seg,
				[2] = update_destination(my_data, follow_unit_nav_seg, data.pos_rsrv_id)
			}
			coarse_path_nr = coarse_path_nr + 1

			CopLogicTravel.itr_simplify_coarse_path(data, my_data)
		end
	end

	data.itr_follow_unit_nav_seg = follow_unit_nav_seg
end

local itr_original_coplogictravel_actioncompleteclbk = CopLogicTravel.action_complete_clbk
function CopLogicTravel.action_complete_clbk(data, action)
	if action.itr_fake_complete then
		local original_expired = action._expired
		action._expired = true
		data.internal_data.itr_want_path_ahead = action
		itr_original_coplogictravel_actioncompleteclbk(data, action)
		action._expired = original_expired
	else
		itr_original_coplogictravel_actioncompleteclbk(data, action)
	end
end
DelayedCalls:Add('DelayedModIter_actioncompleteclbk', 0, function()
	TeamAILogicTravel.action_complete_clbk = CopLogicTravel.action_complete_clbk
end)

local itr_original_coplogictravel_chkrequestactionwalktoadvancepos = CopLogicTravel._chk_request_action_walk_to_advance_pos
function CopLogicTravel._chk_request_action_walk_to_advance_pos(data, my_data, ...)
	itr_original_coplogictravel_chkrequestactionwalktoadvancepos(data, my_data, ...)

	if my_data.path_ahead and my_data.advancing then
		my_data.advancing.itr_path_ahead = true
	end
end

function CopLogicTravel._check_start_path_ahead(data)
	local my_data = data.internal_data

	if my_data.processing_advance_path then
		return
	end

	local objective = data.objective
	local coarse_path = my_data.coarse_path
	if not coarse_path then
		return
	end

	local walk_action = my_data.advancing
	if not walk_action then
		return
	end

	local s_path = walk_action._simplified_path
	if not s_path then
		return
	end

	local from_pos = CopActionWalk._nav_point_pos(s_path[#s_path])

	local next_index = my_data.coarse_path_index + 2
	if next_index > #coarse_path then
		return
	end

	local to_pos = data.logic._get_exact_move_pos(data, next_index)
	my_data.processing_advance_path = true
	local prio = data.logic.get_pathing_prio(data)
	local nav_segs = CopLogicTravel._get_allowed_travel_nav_segs(data, my_data, to_pos)

	data.unit:brain():search_for_path_from_pos(my_data.advance_path_search_id, from_pos, to_pos, prio, nil, nav_segs)
end

local itr_original_coplogictravel_updadvance = CopLogicTravel.upd_advance
function CopLogicTravel.upd_advance(data)
	local my_data = data.internal_data
	if my_data.has_old_action then
		CopLogicAttack._upd_stop_old_action(data, my_data)
	elseif my_data.itr_want_path_ahead then
		if my_data.itr_want_path_ahead.itr_path_ahead then -- if interrupted
			my_data.advancing = my_data.itr_want_path_ahead
			CopLogicTravel._check_start_path_ahead(data)
		end
		my_data.itr_want_path_ahead = nil
	else
		itr_original_coplogictravel_updadvance(data)
	end
end
