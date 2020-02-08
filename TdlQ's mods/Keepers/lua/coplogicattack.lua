local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local kpr_original_coplogicattack_actiontaken = CopLogicAttack.action_taken
function CopLogicAttack.action_taken(data, my_data)
	if data.is_converted and data.kpr_is_keeper and data.kpr_mode == 2 then
		return true
	end

	return kpr_original_coplogicattack_actiontaken(data, my_data)
end

local kpr_original_coplogicattack_chkwantstotakecover = CopLogicAttack._chk_wants_to_take_cover
function CopLogicAttack._chk_wants_to_take_cover(data, my_data)
	if data.kpr_is_keeper and not Keepers:CanSearchForCover(data.unit) then
		return false
	end

	return kpr_original_coplogicattack_chkwantstotakecover(data, my_data)
end

local kpr_original_coplogicattack_updatecover = CopLogicAttack._update_cover
function CopLogicAttack._update_cover(data)
	if data.kpr_mode ~= 2 then
		local attention_obj = data.attention_obj
		if attention_obj and attention_obj.nav_tracker and attention_obj.reaction >= AIAttentionObject.REACT_COMBAT then
			local my_data = data.internal_data
			local find_new = not my_data.moving_to_cover and not my_data.walking_to_cover_shoot_pos and not my_data.surprised
			if find_new then
				local enemy_tracker = attention_obj.nav_tracker
				local threat_pos = enemy_tracker:field_position()
				local near_pos = data.kpr_keep_position
				local best_cover = my_data.best_cover
				if near_pos and (not best_cover or not CopLogicAttack._verify_follow_cover(best_cover[1], near_pos, threat_pos, 200, 1000)) and not my_data.processing_cover_path and not my_data.charge_path_search_id then
					local found_cover = managers.navigation:find_cover_near_pos_1(near_pos, threat_pos, 400, 0, true)
					if found_cover then
						local better_cover = {found_cover}
						CopLogicAttack._set_best_cover(data, my_data, better_cover)
						local offset_pos, yaw = CopLogicAttack._get_cover_offset_pos(data, better_cover, threat_pos)
						if offset_pos then
							better_cover[5] = offset_pos
							better_cover[6] = yaw
						end
					end
				end
			end
			local in_cover = my_data.in_cover
			if in_cover then
				local threat_pos = attention_obj.verified_pos
				in_cover[3], in_cover[4] = CopLogicAttack._chk_covered(data, data.m_pos, threat_pos, data.visibility_slotmask)
			end
			return
		end
	end

	kpr_original_coplogicattack_updatecover(data)
end

function CopLogicAttack.aim_allow_fire(shoot, aim, data, my_data)
	local focus_enemy = data.attention_obj
	if shoot then
		if not my_data.firing then
			data.unit:movement():set_allow_fire(true)
			my_data.firing = true
			-- if bots' masks take too long to load, they enter combat while still being in slot 24, leading to a crash
			local slot = data.unit:slot()
			if slot ~= 16 and slot ~= 24 and data.char_tweak.chatter.aggressive then
				managers.groupai:state():chk_say_enemy_chatter(data.unit, data.m_pos, 'aggressive')
			end
		end
	elseif my_data.firing then
		data.unit:movement():set_allow_fire(false)
		my_data.firing = nil
	end
end
