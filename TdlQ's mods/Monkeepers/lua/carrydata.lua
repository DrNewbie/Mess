local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

if Monkeepers.disabled then
	return
end

local mvec3_cpy = mvector3.copy
local mvec3_dis = mvector3.distance

if Network:is_server() then
	local mkp_original_carrydata_triggerload = CarryData.trigger_load
	function CarryData:trigger_load(instigator)
		self.mkp_callback = nil

		if self._carry_SO_data then
			local carrier = self._carry_SO_data.carrier
			if carrier ~= instigator and alive(carrier) then
				carrier:brain():set_objective(nil)
			end
		end

		if Monkeepers:IsAcceptableCarry(self._carry_id) then
			local interaction = alive(self._unit) and self._unit:interaction()
			local peer = managers.network:session():peer_by_unit(instigator)
			if peer and interaction then
				self:mkp_unregister_carry_SO()

				local peer_id = peer:id()
				local last_interaction_was_carrydrop = interaction.tweak_data:match('carry_drop$')
				Monkeepers.last_interaction_was_carrydrop[peer_id] = last_interaction_was_carrydrop

				local pickup_pos
				local instigator_pos = mvec3_cpy(instigator:position())
				local lv = Monkeepers:FindLootbagVector(instigator:position())
				if self:is_linked_to_unit() then
					-- qued
				elseif not lv or last_interaction_was_carrydrop then
					pickup_pos = mvec3_cpy(instigator_pos)
				end
				Monkeepers.last_carry_pickup_pos[peer_id] = pickup_pos

				if not lv then
					DelayedCalls:Add('DelayedModMKP_triggerload_' .. peer_id, 2, function()
						if alive(instigator) and instigator:movement():current_state_name() == 'carry' then
							if not Monkeepers:BagZiplineNearPos(instigator_pos) then
								local bags = Monkeepers:GetBagsAround(instigator_pos, 700)
								if #bags > 0 then
									for ukey, record in pairs(managers.groupai:state()._ai_criminals) do
										local unit = record.unit
										if alive(unit) and not unit:movement():carrying_bag() then
											local objective = unit:brain():objective()
											if objective and objective.type == 'follow' and objective.follow_unit == instigator then
												local bag = table.remove(bags)
												if not alive(bag) then
													break
												end
												local carry_data = bag.carry_data and bag:carry_data()
												if carry_data then
													carry_data:mkp_chk_register_carry_SO(objective)
												end
											end
										end
									end
								end
							end
						end
					end)
				end
			end
		end

		mkp_original_carrydata_triggerload(self, instigator)
	end
end

local mkp_original_carrydata_chkregisterstealSO = CarryData._chk_register_steal_SO
function CarryData:_chk_register_steal_SO()
	mkp_original_carrydata_chkregisterstealSO(self)
	self:mkp_chk_register_carry_SO()
end

function CarryData:mkp_make_drop_objective(lv)
	local td = tweak_data.carry[self._carry_id]

	local drop_pos = mvec3_cpy(lv.throw_pos)
	local drop_nav_seg = managers.navigation:get_nav_seg_from_pos(drop_pos)
	local drop_area = managers.groupai:state():get_area_from_nav_seg_id(drop_nav_seg)

	local drop_objective = {
		kpr_icon = 'pd2_loot',
		mkp_lv = lv,
		type = 'act',
		action_duration = 0.2,
		haste = tweak_data.carry.types[td.type].can_run and 'run' or 'walk',
		pose = 'stand',
		nav_seg = drop_nav_seg,
		pos = drop_pos,
		rot = lv.rot,
		area = drop_area,
		fail_clbk = callback(self, self, 'mkp_on_carry_SO_failed'),
		complete_clbk = callback(self, self, 'mkp_on_carry_SO_completed', lv),
		action = {
			variant = 'gesture_stop',
			align_sync = true,
			body_part = 1,
			type = 'act',
			blocks = {
				aim = -1,
				turn = -1,
			}
		}
	}

	return drop_objective
end

function CarryData:mkp_make_pickup_objective(followup_objective)
	local tracker_pickup = managers.navigation:create_nav_tracker(self._unit:position(), false)
	local pickup_nav_seg = tracker_pickup:nav_segment()
	local pickup_pos = tracker_pickup:field_position()
	local pickup_area = managers.groupai:state():get_area_from_nav_seg_id(pickup_nav_seg)
	managers.navigation:destroy_nav_tracker(tracker_pickup)

	local difficulty_index = tweak_data:difficulty_to_index(Global.game_settings.difficulty)

	local pickup_objective = {
		kpr_icon = 'wp_arrow',
		destroy_clbk_key = false,
		type = 'act',
		haste = 'run',
		pose = 'crouch',
		interrupt_health = 0.4,
		mkp_crowd_interrupt = math.floor((11 - difficulty_index) * 1.5),
		nav_seg = pickup_nav_seg,
		area = pickup_area,
		pos = pickup_pos,
		mkp_bag = self._unit,
		fail_clbk = callback(self, self, 'mkp_on_pickup_SO_failed'),
		complete_clbk = callback(self, self, 'mkp_on_pickup_SO_completed'),
		action = {
			variant = 'untie',
			align_sync = true,
			body_part = 1,
			type = 'act'
		},
		action_duration = 1,
		followup_objective = followup_objective
	}

	return pickup_objective
end

function CarryData:mkp_chk_register_carry_SO(followup_objective, forced_lv, can_move)
	if not alive(self._unit) then
		return
	end

	if not Network:is_server() or not managers.navigation:is_data_ready() then
		return
	end

	if not can_move then
		local body = self._unit:body('hinge_body_1') or self._unit:body(0)
		if body:active() then
			return
		end
	end

	if self._carry_SO_data then
		local pickup_objective = self._carry_SO_data.pickup_objective
		local current_type = pickup_objective.followup_objective and pickup_objective.followup_objective.type
		if current_type == 'follow' and (not followup_objective or followup_objective.type ~= current_type) then
			local lv = forced_lv or Monkeepers:FindLootbagVector(self._unit:position())
			if lv then
				pickup_objective.followup_objective = self:mkp_make_drop_objective(lv)
			end
		end
		return
	end

	if not Monkeepers:IsAcceptableCarry(self._carry_id) then
		return
	end

	local lv, drop_objective
	if followup_objective then
		drop_objective = followup_objective
	else
		lv = forced_lv or Monkeepers:FindLootbagVector(self._unit:position())
		if not lv then
			return
		end
		drop_objective = self:mkp_make_drop_objective(lv)
	end

	local pickup_objective = self:mkp_make_pickup_objective(drop_objective)

	local so_descriptor = {
		interval = 1,
		base_chance = 1,
		chance_inc = 0,
		usage_amount = 1,
		objective = pickup_objective,
		search_pos = pickup_objective.pos,
		verification_clbk = callback(self, self, 'mkp_clbk_pickup_SO_verification'),
		AI_group = 'friendlies',
		admin_clbk = callback(self, self, 'mkp_on_pickup_SO_administered')
	}

	local so_id = 'mkp_monkey_' .. tostring(self._unit:key())
	self._carry_SO_data = {
		mkp_lv = lv,
		SO_registered = true,
		picked_up = false,
		SO_id = so_id,
		pickup_area = pickup_objective.area,
		pickup_objective = pickup_objective
	}

	managers.groupai:state():add_special_objective(so_id, so_descriptor)
end

CarryData.mkp_unregister_steal_SO = CarryData._unregister_steal_SO
function CarryData:_unregister_steal_SO()
	self:mkp_unregister_steal_SO()
	self:mkp_unregister_carry_SO()
end

function CarryData:mkp_unregister_carry_SO()
	if self._carry_SO_data and (self._carry_SO_data.SO_registered or self._carry_SO_data.carrier) then
		managers.groupai:state():remove_special_objective(self._carry_SO_data.SO_id)
		self._carry_SO_data = nil
	end
end

function CarryData:mkp_clbk_pickup_SO_verification(candidate_unit)
	if not self._carry_SO_data or not self._carry_SO_data.SO_id then
		return
	end

	local candidate_movement = candidate_unit:movement()
	if candidate_movement:cool() then
		return
	end

	if candidate_movement.carrying_bag and candidate_movement:carrying_bag() then
		return
	end

	if candidate_movement:chk_action_forbidden('walk') then
		return
	end

	if candidate_unit:base().kpr_is_keeper then
		return
	end

	local lv = self._carry_SO_data.mkp_lv
	if lv and lv.dropzone and not Monkeepers:IsDropzoneOK(lv.dropzone, lv.position) then
		return
	end

	local objective = candidate_unit:brain():objective()
	if objective and objective.type == 'revive' then
		return
	end

	for id, so in pairs(managers.groupai:state()._special_objectives) do
		if so.data and so.data.AI_group == 'friendlies' and type(id) == 'string' and id:find('revive') then
			return
		end
	end

	if lv then
		local t = TimerManager:game():time()
		if lv.failed_t and t - lv.failed_t < 15 then
			return
		end

		if Monkeepers:MoreImportantBagExist(lv) then
			return
		end
	end

	return true
end

function CarryData:mkp_on_pickup_SO_administered(carrier)
	self._carry_SO_data.carrier = carrier
	self._carry_SO_data.SO_registered = false
	managers.groupai:state():unregister_loot(self._unit:key())
end

function CarryData:mkp_on_pickup_SO_completed(carrier)
	if not self._carry_SO_data then
		carrier:brain():set_objective(nil)
		return
	elseif not self._carry_SO_data.carrier then
		carrier:brain():set_objective(nil)
		return
	elseif self._carry_SO_data.carrier ~= carrier then
		carrier:brain():set_objective(nil)
		return
	end

	local mkp_lv = self._carry_SO_data.mkp_lv
	if mkp_lv and mkp_lv.dropzone and not Monkeepers:IsDropzoneOK(mkp_lv.dropzone, mkp_lv.position) then
		carrier:brain():set_objective(nil)
		return
	end

	if carrier:movement():carrying_bag() then
		carrier:brain():set_objective(nil)
		return
	end

	if not alive(self._unit) then
		carrier:brain():set_objective(nil)
		return
	end

	local objective = carrier:brain():objective()
	local follow_unit = objective and objective.follow_unit
	if alive(follow_unit) and follow_unit:movement():current_state_name() ~= 'carry' then
		self._carry_SO_data = nil
		self:mkp_chk_register_carry_SO()
		carrier:brain():set_objective(nil)
		return
	end

	if self._steal_SO_data and alive(self._steal_SO_data.thief) then
		self._steal_SO_data.thief:brain():set_objective(nil)
	end
	self:mkp_unregister_steal_SO()

	self._carry_SO_data.picked_up = true
	self:link_to(carrier, false)
	self:trigger_load(carrier)
end

local mkp_original_carrydata_onpickupsocompleted = CarryData.on_pickup_SO_completed
function CarryData:on_pickup_SO_completed(thief)
	if self._carry_SO_data and alive(self._carry_SO_data.carrier) then
		self._carry_SO_data.carrier:brain():set_objective(nil)
	end
	self:mkp_unregister_carry_SO()
	mkp_original_carrydata_onpickupsocompleted(self, thief)
end

function CarryData:mkp_on_pickup_SO_failed(carrier)
	if not self._carry_SO_data then
		return
	elseif not self._carry_SO_data.carrier then
		return
	elseif self._carry_SO_data.carrier ~= carrier then
		return
	end

	if self._carry_SO_data.mkp_lv then
		self._carry_SO_data.mkp_lv.failed_t = TimerManager:game():time()
	end

	self._carry_SO_data = nil
	self:mkp_chk_register_carry_SO()
end

local mkp_original_carrydata_onpickupsofailed = CarryData.on_pickup_SO_failed
function CarryData:on_pickup_SO_failed(thief)
	if self._steal_SO_data then
		mkp_original_carrydata_onpickupsofailed(self, thief)
	end
end

function CarryData:mkp_on_carry_SO_completed(lv, carrier)
	if not self._carry_SO_data then
		-- qued
	elseif not self._carry_SO_data.carrier then
		return
	elseif self._carry_SO_data.carrier ~= carrier then
		return
	end

	self._carry_SO_data = nil
	if alive(self._unit) then
		self:unlink()

		if not lv.dropzone or Monkeepers:IsDropzoneOK(lv.dropzone, lv.position) then
			local throw_distance_multiplier = managers.player:upgrade_value_by_level('carry', 'throw_distance_multiplier', lv.throw_distance_multiplier_upgrade_level, 1)
			local carry_type = tweak_data.carry[self._carry_id].type
			throw_distance_multiplier = throw_distance_multiplier * tweak_data.carry.types[carry_type].throw_distance_multiplier
			self:set_position_and_throw(self._unit:position(), lv.dir * 600 * throw_distance_multiplier, 100)
		end
	end
end

local mkp_original_carrydata_setpositionandthrow = CarryData.set_position_and_throw
function CarryData:set_position_and_throw(...)
	self.mkp_throw_t = TimerManager:game():time()
	mkp_original_carrydata_setpositionandthrow(self, ...)
end

function CarryData:mkp_on_carry_SO_failed(carrier)
	if not self._carry_SO_data then
		return
	elseif not self._carry_SO_data.carrier then
		return
	elseif self._carry_SO_data.carrier ~= carrier then
		return
	end

	local lv = self._carry_SO_data.mkp_lv
	if lv then
		lv.failed_t = TimerManager:game():time()
	end
	self._carry_SO_data = nil
	if alive(self._unit) then
		self:mkp_chk_register_carry_SO(nil, lv)
		self:unlink()
	end
end

local mkp_original_carrydata_clbkbodyactivestate = CarryData.clbk_body_active_state
function CarryData:clbk_body_active_state(...)
	-- don't think bag has arrived when it has not even left yet
	if not self.mkp_throw_t or TimerManager:game():time() - self.mkp_throw_t > 0.5 then
		mkp_original_carrydata_clbkbodyactivestate(self, ...)
	end
end

local mkp_original_carrydata_updatethrowlink = CarryData._update_throw_link
function CarryData:_update_throw_link(unit, t, dt)
	if not self.mkp_throw_t then
		mkp_original_carrydata_updatethrowlink(self, unit, t, dt)
	end
end

local mkp_original_carrydata_linkto = CarryData.link_to
function CarryData:link_to(parent_unit, ...)
	if self._steal_SO_data and self._steal_SO_data.thief == parent_unit then
		self.mkp_stolen_position = self.mkp_stolen_position or mvec3_cpy(parent_unit:position())
	else
		self.mkp_stolen_position = nil
	end

	return mkp_original_carrydata_linkto(self, parent_unit, ...)
end

function CarryData:mkp_register_putbackintoplace_SO()
	if self._carry_SO_data or self:is_linked_to_unit() then
		return
	end

	if not self.mkp_stolen_position then
		return
	end

	local fake_lv = {
		created_t = 0,
		throw_pos = mvec3_cpy(self.mkp_stolen_position),
		land_pos = mvec3_cpy(self.mkp_stolen_position),
		rot = Rotation(0, 0, 0),
		dir = Vector3(0, 0, 0),
		throw_distance_multiplier_upgrade_level = 0,
	}
	self:mkp_chk_register_carry_SO(nil, fake_lv, true)

	return true
end

function CarryData:mkp_assign_SO(bot_unit)
	if not alive(bot_unit) then
		return
	end

	if not self._carry_SO_data or not self._carry_SO_data.SO_registered or self._carry_SO_data.carrier and self._carry_SO_data.carrier ~= bot_unit then
		return
	end

	local so_id = self._carry_SO_data.SO_id
	if not so_id then
		return
	end

	local gstate = managers.groupai:state()
	local so = gstate._special_objectives[so_id]
	local so_data = so and so.data
	if not so_data then
		return
	end

	if so_data.verification_clbk and not so_data.verification_clbk(bot_unit) then
		return
	end

	local obj = gstate.clone_objective(so_data.objective)
	bot_unit:brain():set_objective(obj)

	if so_data.admin_clbk then
		so_data.admin_clbk(bot_unit)
	end

	gstate:remove_special_objective(so_id)

	return obj
end
