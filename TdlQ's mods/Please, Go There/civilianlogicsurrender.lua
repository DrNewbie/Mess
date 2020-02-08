local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local pgt_original_civilianlogicsurrender_enter = CivilianLogicSurrender.enter
function CivilianLogicSurrender.enter(data, new_logic_name, enter_params)
	local old_data = data.internal_data
	pgt_original_civilianlogicsurrender_enter(data, new_logic_name, enter_params)
	local my_data = data.internal_data
	my_data.rebellion_meter = old_data.rebellion_meter
	my_data.check_surroundings_t = old_data.check_surroundings_t

	local force_lie_down = enter_params and enter_params.force_lie_down or false
	local anim_data = data.unit:anim_data()
	if (force_lie_down or anim_data.drop) and not anim_data.tied then
		data.unit:interaction():set_active(true, true)
		my_data.interaction_active = true
	end
end

function CivilianLogicSurrender.pgt_reset_rebellion(data)
	data.internal_data.rebellion_meter = 0
	data.unit:contour():fade_color(1)
	FadingContour.SynchronizeFadeLevel(data.unit, 1, true)
end

local pgt_original_civilianlogicsurrender_onalert = CivilianLogicSurrender.on_alert
function CivilianLogicSurrender.on_alert(data, alert_data)
	if data.is_tied and data.unit:anim_data().stand then
		CivilianLogicSurrender.pgt_on_alert(data, alert_data)
	else
		pgt_original_civilianlogicsurrender_onalert(data, alert_data)
	end
end

local rebellion_max = 20 + (8 - tweak_data:difficulty_to_index(Global.game_settings and Global.game_settings.difficulty or 'normal'))
function CivilianLogicSurrender.pgt_update_rebellion(data, rebellion)
	local my_data = data.internal_data
	if data.t - my_data.state_enter_t < 1 then
		return
	end

	my_data.rebellion_meter = my_data.rebellion_meter + rebellion
	local ratio = math.floor(rebellion_max - my_data.rebellion_meter) / rebellion_max
	if ratio > 0 then
		data.unit:contour():fade_color(ratio)
		FadingContour.SynchronizeFadeLevel(data.unit, ratio)
	else
		data.unit:brain():on_hostage_move_interaction(nil, 'stay')
		return true
	end
end

local function has_stockholm_syndrome(unit)
	local u_base = unit:base()
	if not u_base then
	elseif u_base.is_local_player then
		if managers.player:has_category_upgrade('player', 'civ_calming_alerts') then
			return true
		end
	elseif u_base.is_husk_player and u_base:upgrade_value('player', 'civ_calming_alerts') then
		return true
	end
end

local alert_dis_thresholds = {
	bullet = 4000,
	vo_intimidate = 1500,
	aggression = 1500,
	explosion = 4000
}
local mask_enemies
function CivilianLogicSurrender.pgt_on_alert(data, alert_data)
	local alert_type = alert_data[1]
	local threshold = alert_dis_thresholds[alert_type]
	local alert_dis = mvector3.distance(data.m_pos, alert_data[2])
	if alert_dis < threshold then
		local rebellion = (threshold - alert_dis) / threshold
		local aggressor = alert_data[5]
		if alive(aggressor) then
			if has_stockholm_syndrome(aggressor) then
				rebellion = rebellion * (-1)
			else
				mask_enemies = mask_enemies or managers.slot:get_mask('enemies')
				if not aggressor:in_slot(mask_enemies) then
					rebellion = 0
				end
			end
		end
		if rebellion ~= 0 then
			CivilianLogicSurrender.pgt_update_rebellion(data, rebellion)
		end
	end
end

local cop_pos = Vector3()
local visibility_slotmask, enemies_slotmask
function CivilianLogicSurrender.pgt_check_surroundings(data)
	local my_data = data.internal_data
	if data.t - my_data.check_surroundings_t > 0.3 then
		my_data.check_surroundings_t = data.t
		enemies_slotmask = enemies_slotmask or managers.slot:get_mask('enemies')
		visibility_slotmask = visibility_slotmask or managers.slot:get_mask('AI_graph_obstacle_check')

		local head_pos = data.unit:movement():m_head_pos()
		local nearby_cops = World:find_units_quick('intersect', 'cylinder', data.m_pos, head_pos, 1500, enemies_slotmask)

		local rebellion = 0
		local my_key = data.key
		for _, unit in ipairs(nearby_cops) do
			if not unit:brain():is_hostage() then
				mvector3.set(cop_pos, unit:movement():m_head_pos())
				local vis_ray = World:raycast('ray', head_pos, cop_pos, 'slot_mask', visibility_slotmask, 'ray_type', 'ai_vision')
				if not vis_ray or vis_ray.unit:key() == my_key then
					local dis = mvector3.distance(head_pos, cop_pos)
					rebellion = rebellion + (500 / dis)
				end
			end
		end

		if rebellion > 0 then
			return CivilianLogicSurrender.pgt_update_rebellion(data, rebellion)
		end
	end
end

local pgt_original_civilianlogicsurrender_queuedupdate = CivilianLogicSurrender.queued_update
function CivilianLogicSurrender.queued_update(rubbish, data)
	if data.unit:base().pgt_is_being_moved then
		data.t = TimerManager:game():time()
		if CivilianLogicSurrender.pgt_check_surroundings(data) then
			return
		end
	end

	pgt_original_civilianlogicsurrender_queuedupdate(rubbish, data)
end
