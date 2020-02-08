local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local REACT_IDLE = AIAttentionObject.REACT_IDLE
local mvec3_add = mvector3.add
local mvec3_mul = mvector3.multiply
local mvec3_set = mvector3.set
local temp_vec1 = Vector3()
local temp_vec2 = Vector3()

local fs_original_copbrain_clbkdeath = CopBrain.clbk_death
function CopBrain:clbk_death(my_unit, damage_info)
	local gstate = managers.groupai:state()
	if gstate:whisper_mode() then
		fs_original_copbrain_clbkdeath(self, my_unit, damage_info)
	else
		local my_unit_key = my_unit:key()
		for u_key, unit in pairs(gstate._converted_police) do
			if u_key == my_unit_key then
				for _, cop_unit in pairs(managers.enemy:all_enemies()) do
					local attention_info = cop_unit.brain and cop_unit:brain()._logic_data.detected_attention_objects[my_unit_key]
					if attention_info then
						attention_info.previous_reaction = REACT_IDLE
					end
				end
			else
				local attention_info = unit:brain()._logic_data.detected_attention_objects[my_unit_key]
				if attention_info then
					attention_info.previous_reaction = REACT_IDLE
				end
			end
		end
		fs_original_copbrain_clbkdeath(self, my_unit, damage_info)
		gstate:unregister_AI_attention_object(my_unit_key)
	end
end

local fs_original_copbrain_converttocriminal = CopBrain.convert_to_criminal
function CopBrain:convert_to_criminal(mastermind_criminal)
	fs_original_copbrain_converttocriminal(self, mastermind_criminal)
	self._unit:movement().fs_do_track = nil
	local cur_seg = self._unit:movement().fs_cur_seg
	if cur_seg then
		FullSpeedSwarm.units_per_navseg[cur_seg][self._unit:key()] = nil
	end
end

local fs_original_copbrain_oncriminalneutralized = CopBrain.on_criminal_neutralized
function CopBrain:on_criminal_neutralized(criminal_key)
	fs_original_copbrain_oncriminalneutralized(self, criminal_key)
	local attention_info = self._logic_data.detected_attention_objects[criminal_key]
	if attention_info then
		attention_info.previous_reaction = nil
	end
end

function CopBrain:action_complete_clbk(action)
	if not action.itr_fake_complete then
		if action.chk_block then
			local u_mov = self._unit:movement()
			u_mov.fs_blockers_nr = u_mov.fs_blockers_nr - 1
		end

		local action_desc = action._action_desc
		if action_desc and action_desc.variant and action_desc.variant:find('e_so_sup_fumble_inplace') == 1 then
			local u_mov = self._unit:movement()
			if u_mov._action_common_data.is_suppressed and action.expired and action:expired() then
				local allowed_fumbles = {'e_so_sup_fumble_inplace_3'}

				if u_mov._suppression.transition then
					local vec_from = temp_vec1
					local vec_to = temp_vec2
					local ray_params = {
						allow_entry = false,
						trace = true,
						tracker_from = u_mov:nav_tracker(),
						pos_from = vec_from,
						pos_to = vec_to
					}

					local m_pos = u_mov:m_pos()
					local m_rot = u_mov:m_rot()

					mvec3_set(vec_from, m_pos)
					mvec3_set(vec_to, m_rot:y())
					mvec3_mul(vec_to, -100)
					mvec3_add(vec_to, m_pos)
					local allow = not managers.navigation:raycast(ray_params)
					if allow then
						table.insert(allowed_fumbles, 'e_so_sup_fumble_inplace_1')
					end

					mvec3_set(vec_from, m_pos)
					mvec3_set(vec_to, m_rot:x())
					mvec3_mul(vec_to, 200)
					mvec3_add(vec_to, m_pos)
					allow = not managers.navigation:raycast(ray_params)
					if allow then
						table.insert(allowed_fumbles, 'e_so_sup_fumble_inplace_2')
					end

					mvec3_set(vec_from, m_pos)
					mvec3_set(vec_to, m_rot:x())
					mvec3_mul(vec_to, -200)
					mvec3_add(vec_to, m_pos)
					allow = not managers.navigation:raycast(ray_params)
					if allow then
						table.insert(allowed_fumbles, 'e_so_sup_fumble_inplace_4')
					end
				end

				local action_desc = {
					body_part = 1,
					type = 'act',
					variant = allowed_fumbles[math.random(#allowed_fumbles)],
					blocks = {
						action = -1,
						walk = -1
					}
				}
				u_mov:action_request(action_desc)
			end
		end
	end

	self._current_logic.action_complete_clbk(self._logic_data, action)
end

local fs_original_copbrain_resetlogicdata = CopBrain._reset_logic_data
function CopBrain:_reset_logic_data()
	fs_original_copbrain_resetlogicdata(self)
	self._logic_data._tweak_table = self._unit:base()._tweak_table
end
