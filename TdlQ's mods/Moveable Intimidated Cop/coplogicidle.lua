local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local math_floor = math.floor
local math_min = math.min

local mic_original_coplogicidle_enter = CopLogicIdle.enter
function CopLogicIdle.enter(data, new_logic_name, enter_params)
	if not data.mic_is_being_moved then
		return mic_original_coplogicidle_enter(data, new_logic_name, enter_params)
	end

	local weap_name = data.unit:base():default_weapon_name()
	if weap_name then
		data.unit:inventory():add_unit_by_name(weap_name, true, true)
	end

	local old_data = data.internal_data
	mic_original_coplogicidle_enter(data, new_logic_name, enter_params)
	data.brain:set_attention_settings({corpse_sneak = true})

	local my_data = data.internal_data
	my_data.weapon_range = nil
	data.unit:inventory():destroy_all_items()

	data.unit:movement():action_request({ type = 'act', body_part = 1, variant = 'hands_up' })
	my_data.is_hostage = data.mic_is_being_moved
	my_data.rebellion_meter = old_data.rebellion_meter
	my_data.check_surroundings_t = old_data.check_surroundings_t
	my_data.state_enter_t = old_data.state_enter_t
end

local mic_original_coplogicidle_getpriorityattention = CopLogicIdle._get_priority_attention
function CopLogicIdle._get_priority_attention(data, attention_objects, reaction_func)
	if not data.mic_is_being_moved then
		return mic_original_coplogicidle_getpriorityattention(data, attention_objects, reaction_func)
	end
end

function CopLogicIdle.mic_reset_rebellion(data)
	data.internal_data.rebellion_meter = 0
	data.unit:contour():fade_color(1)
	FadingContour.SynchronizeFadeLevel(data.unit, 1, true)
end

local rebellion_max = 20 + (8 - tweak_data:difficulty_to_index(Global.game_settings and Global.game_settings.difficulty or 'normal'))
function CopLogicIdle.mic_update_rebellion(data, rebellion)
	local my_data = data.internal_data
	if data.t - my_data.state_enter_t < 1 then
		return
	end
	my_data.rebellion_meter = my_data.rebellion_meter + rebellion
	local ratio = math_floor(rebellion_max - my_data.rebellion_meter) / rebellion_max
	if ratio > 0 then
		data.unit:contour():fade_color(ratio)
		FadingContour.SynchronizeFadeLevel(data.unit, ratio)
	else
		data.unit:brain():on_hostage_move_interaction(data.mic_is_being_moved, 'fail')
	end
end

local alert_dis_thresholds = {
	bullet = 4000,
	vo_cbt = 1500,
	vo_intimidate = 1500,
	aggression = 1500,
	explosion = 4000
}
function CopLogicIdle.mic_on_alert(data, alert_data)
	local alert_type = alert_data[1]
	local threshold = alert_dis_thresholds[alert_type]
	local alert_dis = mvector3.distance(data.m_pos, alert_data[2])
	if alert_dis < threshold then
		local rebellion = (threshold - alert_dis) / threshold
		CopLogicIdle.mic_update_rebellion(data, rebellion)
	end
end

local top_pos = Vector3()
local bottom_pos = Vector3()
local cop_pos = Vector3()
local visibility_slotmask, enemies_slotmask
function CopLogicIdle.mic_check_surroundings(data)
	local my_data = data.internal_data
	if data.t - my_data.check_surroundings_t > 0.3 then
		my_data.check_surroundings_t = data.t
		enemies_slotmask = enemies_slotmask or managers.slot:get_mask('enemies')
		visibility_slotmask = visibility_slotmask or managers.slot:get_mask('AI_graph_obstacle_check')

		local head_pos = data.unit:movement():m_head_pos()
		mvector3.set(top_pos, head_pos)
		mvector3.set_z(top_pos, top_pos.z + 50)
		mvector3.set(bottom_pos, data.m_pos)
		mvector3.set_z(bottom_pos, bottom_pos.z - 50)
		local nearby_cops = World:find_units_quick('cylinder', bottom_pos, top_pos, 1500, enemies_slotmask)

		local rebellion = 0
		local my_key = data.key
		for _, unit in pairs(nearby_cops) do
			if unit:key() ~= my_key and not unit:brain():is_hostage() then
				mvector3.set(cop_pos, unit:movement():m_head_pos())
				local vis_ray = World:raycast('ray', head_pos, cop_pos, 'slot_mask', visibility_slotmask, 'ray_type', 'ai_vision')
				if not vis_ray or vis_ray.unit:key() == my_key then
					local dis = mvector3.distance(head_pos, cop_pos)
					rebellion = rebellion + (500 / dis)
				end
			end
		end

		if rebellion > 0 then
			CopLogicIdle.mic_update_rebellion(data, rebellion)
		end
	end

	return 0.3
end

local mic_original_coplogicidle_onalert = CopLogicIdle.on_alert
function CopLogicIdle.on_alert(data, alert_data)
	if data.mic_is_being_moved then
		CopLogicIdle.mic_on_alert(data, alert_data)
	else
		mic_original_coplogicidle_onalert(data, alert_data)
	end
end

local mic_original_coplogicidle_updenemydetection = CopLogicIdle._upd_enemy_detection
function CopLogicIdle._upd_enemy_detection(data)
	local delay = data.internal_data.detection and mic_original_coplogicidle_updenemydetection(data) or 0.2
	return data.mic_is_being_moved and math_min(delay, CopLogicIdle.mic_check_surroundings(data)) or delay
end
