local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local mvec3_dis_sq = mvector3.distance_sq

local mkp_original_coplogicbase_isobstructed = CopLogicBase.is_obstructed
function CopLogicBase.is_obstructed(data, objective, strictness, attention)
	if objective and objective.mkp_crowd_interrupt then
		if managers.groupai:state():phalanx_vip() then
			return true, true
		end

		local action = data.unit:movement()._active_actions[1]
		if action and action._action_desc and action._action_desc.variant == 'untie' then
			return false, false
		else
			local closer_enemies_nr = 0
			local obj_pos = objective.pos
			local my_dis_to_obj = mvec3_dis_sq(obj_pos, data.m_pos)
			for u_key, attention_info in pairs(data.detected_attention_objects) do
				if attention_info.verified and attention_info.is_alive and attention_info.char_tweak then
					if not data.enemy_slotmask or attention_info.unit:in_slot(data.enemy_slotmask) then
						if mvec3_dis_sq(obj_pos, attention_info.m_pos) < my_dis_to_obj then
							local enemy_weight = {
								medic = 2,
								shield = 2,
								spooc = 5,
								tank = 4,
								taser = 3,
							}
							local tags = attention_info.char_tweak.tags
							local tag = tags and tags[2] -- 1 is law
							closer_enemies_nr = closer_enemies_nr + (tag and enemy_weight[tag] or 1)
						end
					end
				end
			end
			if closer_enemies_nr > objective.mkp_crowd_interrupt then
				return true, true
			end
		end
	end

	return mkp_original_coplogicbase_isobstructed(data, objective, strictness, attention)
end
