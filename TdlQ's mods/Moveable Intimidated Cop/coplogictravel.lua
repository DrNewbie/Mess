local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local mic_original_coplogictravel_enter = CopLogicTravel.enter
function CopLogicTravel.enter(data, new_logic_name, enter_params)
	if not data.mic_is_being_moved then
		return mic_original_coplogictravel_enter(data, new_logic_name, enter_params)
	end

	local weap_name = data.unit:base():default_weapon_name()
	if weap_name then
		data.unit:inventory():add_unit_by_name(weap_name, true, true)
	end

	local old_data = data.internal_data
	mic_original_coplogictravel_enter(data, new_logic_name, enter_params)
	data.brain:set_attention_settings({corpse_sneak = true})

	local my_data = data.internal_data
	my_data.weapon_range = nil
	data.unit:inventory():destroy_all_items()

	if data.unit:anim_data().pose ~= 'stand' then
		data.unit:movement():action_request({ type = 'act', body_part = 1, variant = 'stand' })
	end
	my_data.is_hostage = data.mic_is_being_moved
	my_data.rebellion_meter = old_data.rebellion_meter
	my_data.check_surroundings_t = old_data.check_surroundings_t
	my_data.path_safely = nil
	my_data.has_old_action = nil
	my_data.state_enter_t = old_data.state_enter_t
	my_data.itr_direct_to_pos = data.mic_destination
end

local mic_original_coplogictravel_updenemydetection = CopLogicTravel._upd_enemy_detection
function CopLogicTravel._upd_enemy_detection(data)
	return data.mic_is_being_moved and CopLogicIdle.mic_check_surroundings(data) or mic_original_coplogictravel_updenemydetection(data)
end

local mic_original_coplogictravel_onalert = CopLogicTravel.on_alert
function CopLogicTravel.on_alert(data, alert_data)
	if data.mic_is_being_moved then
		CopLogicIdle.mic_on_alert(data, alert_data)
	else
		mic_original_coplogictravel_onalert(data, alert_data)
	end
end

local mic_original_coplogictravel_determinedestinationoccupation = CopLogicTravel._determine_destination_occupation
function CopLogicTravel._determine_destination_occupation(data, objective)
	local occupation

	if data.mic_is_being_moved and (objective.type == 'follow' or objective.type == 'dont_follow') then
		occupation = {type = 'defend', cover = false, pos = data.unit:base().mic_destination or objective.follow_unit:movement():nav_tracker():field_position()}
	else
		occupation = mic_original_coplogictravel_determinedestinationoccupation(data, objective)
	end

	return occupation
end

local mic_original_coplogictravel_ondestinationreached = CopLogicTravel._on_destination_reached
function CopLogicTravel._on_destination_reached(data)
	if data.mic_destination then
		data.brain:on_hostage_move_interaction(data.mic_is_being_moved, 'fail')
		return
	end

	mic_original_coplogictravel_ondestinationreached(data)
end
