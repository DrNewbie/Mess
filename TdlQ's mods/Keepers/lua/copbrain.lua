local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local kpr_original_copbrain_isavailableforassignment = CopBrain.is_available_for_assignment
function CopBrain:is_available_for_assignment(objective)
	local data = self._logic_data
	if data.kpr_is_keeper and not (objective and objective.type == 'revive') then
		return
	end

	return kpr_original_copbrain_isavailableforassignment(self, objective)
end

function CopBrain:kpr_get_position_around(dest_pos, radius)
	local navman = managers.navigation
	local ray_params = {
		pos_from = dest_pos,
	}

	local function is_ok(pos)
		if mvector3.distance(pos, dest_pos) > 60 then
			ray_params.pos_to = pos
			if not navman:raycast(ray_params) then
				if managers.groupai:state():kpr_count_teammates_near_pos(pos) == 0 then
					return true
				end
			end
		end
	end

	local cover = navman:find_cover_near_pos_1(dest_pos, nil, radius, 0, true)
	if cover and is_ok(cover[1]) then
		local my_data = self._logic_data.internal_data
		if my_data.nearest_cover then
			navman:release_cover(my_data.nearest_cover[1])
		end
		navman:reserve_cover(cover, self._unit:movement():pos_rsrv_id())
		my_data.nearest_cover = {cover}
		return cover[1]
	end

	local poswall = CopLogicTravel._get_pos_on_wall(dest_pos, radius)
	if is_ok(poswall) then
		return poswall
	end

	local slice_nr = 10
	local a = math.random(slice_nr - 1)
	for dist = 200, 100, -100 do
		for attempts = 1, slice_nr do
			local pos_around = dest_pos + Polar(dist, 0, 0):with_spin(a * 360 / slice_nr):to_vector()
			local tracker = navman:create_nav_tracker(pos_around)
			local proper_pos_around = tracker:field_position()
			navman:destroy_nav_tracker(tracker)

			if is_ok(proper_pos_around) then
				return proper_pos_around
			end
			a = (a + 1) % slice_nr
		end
	end

	return dest_pos
end

local kpr_original_copbrain_setobjective = CopBrain.set_objective
function CopBrain:set_objective(new_objective, params)
	local data = self._logic_data
	local is_converted = data.is_converted
	if is_converted or data.team and data.team.id == 'criminal1' then
		local icon, ext_data
		local old_objective = data.objective

		if new_objective and new_objective.follow_unit and not new_objective.follow_unit:alive() then
			new_objective = nil
		end

		if new_objective and not new_objective.forced then
			icon = new_objective.kpr_icon
			local new_obj_type = new_objective.type
			if new_obj_type == 'follow' or new_obj_type == 'stop' or new_obj_type == 'defend_area' then
				if not new_objective.kpr_objective and data.kpr_is_keeper then
					data.objective = Keepers:GetStayObjective(self._unit)
					CopLogicBase.on_new_objective(data, old_objective)
					if Keepers:CanChangeState(self._unit) then
						self:set_logic('travel')
						if is_converted then
							self._unit:movement():action_request({
								type = 'idle',
								body_part = 1,
								sync = true
							})
						end
					end
					Keepers:ResetLabel(self._unit, is_converted, data.objective.kpr_icon, ext_data)
					return
				end
			elseif new_obj_type == 'revive' then
				icon = Keepers.icons.revive
				new_objective.kpr_icon = icon
				local patient = new_objective.follow_unit
				local peer = managers.network:session():peer_by_unit(patient)
				ext_data = peer and peer:id() or 0

				local patient_key = patient:key()
				local restore_special_mode_list = Keepers.rescuers[patient_key] or {}
				Keepers.rescuers[patient_key] = restore_special_mode_list

				local patient_pos = patient:position()
				for _, assistant_unit in ipairs(Keepers:GetReviveAssistants(patient)) do
					if assistant_unit ~= self._unit and not restore_special_mode_list[assistant_unit] then
						restore_special_mode_list[assistant_unit] = Keepers:GetSpecialModeValues(assistant_unit)
						local pos = self:kpr_get_position_around(patient_pos, 400)
						Keepers:SetState(Keepers:GetLuaNetworkingText(ext_data, assistant_unit, 3), true, pos, Keepers.icons.assist)
					end
				end

				if data.kpr_keep_position then
					local obj = new_objective
					while obj.followup_objective do
						obj = obj.followup_objective
					end
					obj.followup_objective = Keepers:GetStayObjective(self._unit)

					local params
					if old_objective and old_objective.kpr_icon == Keepers.icons.assist then
						for k, l in pairs(Keepers.rescuers) do
							params = l[self._unit]
							if params then
								l[self._unit] = nil
								break
							end
						end
					else
						params = Keepers:GetSpecialModeValues(self._unit)
					end
					restore_special_mode_list[self._unit] = params
					Keepers:SetState(Keepers:GetLuaNetworkingText(ext_data, self._unit, 1), false)
				end
			end
		end

		if not icon and old_objective and old_objective.kpr_icon then
			icon = false
		end

		if self:is_active() then
			Keepers:ResetLabel(self._unit, is_converted, icon, ext_data)
		end
	end

	kpr_original_copbrain_setobjective(self, new_objective, params)
end

local kpr_original_copbrain_converttocriminal = CopBrain.convert_to_criminal
function CopBrain:convert_to_criminal(mastermind_criminal)
	kpr_original_copbrain_converttocriminal(self, mastermind_criminal)

	local ct = deep_clone(self._logic_data.char_tweak)
	ct.access = 'teamAI1'
	if Keepers.settings.jokers_run_like_teamais then
		ct.crouch_move = false
		ct.kpr_tweak_table = 'russian'
		ct.move_speed = tweak_data.character.russian.move_speed
		ct.suppression = tweak_data.character.russian.suppression
	end
	self._logic_data.important = true
	self._logic_data.char_tweak = ct
	self._unit:movement():tweak_data_clbk_reload(ct)
	self._unit:character_damage()._char_tweak = ct

	self._unit:base().kpr_minion_owner_peer_id = alive(mastermind_criminal) and managers.network:session():peer_by_unit(mastermind_criminal):id() or 1
end

local kpr_original_copbrain_setimportant = CopBrain.set_important
function CopBrain:set_important(state)
	if self._logic_data.is_converted then
		state = true
	end
	kpr_original_copbrain_setimportant(self, state)
end
