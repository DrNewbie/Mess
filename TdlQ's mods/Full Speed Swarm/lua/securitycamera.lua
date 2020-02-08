local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local tmp_vec1 = Vector3()
local mvec3_dir = mvector3.direction
local REACT_SUSPICIOUS = AIAttentionObject.REACT_SUSPICIOUS
local REACT_MAX = AIAttentionObject.REACT_MAX
function SecurityCamera:_upd_acquire_new_attention_objects(t)
	local all_attention_objects = managers.groupai:state():get_AI_attention_objects_by_filter_i(self._SO_access_str)
	local detected_obj = self._detected_attention_objects
	local my_key = self._u_key
	local my_pos = self._pos
	local my_fwd = self._look_fwd
	local my_access = self._SO_access
	local my_team = self._team
	local attention_cache_key = REACT_SUSPICIOUS .. my_access .. REACT_MAX .. (my_team and my_team.id or '')

	local all_attention_objects_nr = #all_attention_objects
	for i = 1, all_attention_objects_nr do
		local attention_info = all_attention_objects[i]
		local u_key = attention_info.unit_key

		if not detected_obj[u_key] and u_key ~= my_key then
			local attention_info_handler = attention_info.handler
			local settings = attention_info_handler.rel_cache[attention_cache_key]
			if settings == nil then
				settings = attention_info_handler:get_attention_no_cache_query(attention_cache_key, my_access, REACT_SUSPICIOUS, REACT_MAX, my_team)
			end
			if settings then
				local attention_pos = attention_info_handler:get_detection_m_pos()
				if self:_detection_angle_and_dis_chk(my_pos, my_fwd, attention_info_handler, settings, attention_pos) then
					local vis_ray = self._unit:raycast('ray', my_pos, attention_pos, 'slot_mask', self._visibility_slotmask, 'ray_type', 'ai_vision')
					if not vis_ray or vis_ray.unit:key() == u_key then
						local in_cone = true
						if self._cone_angle ~= nil then
							mvec3_dir(tmp_vec1, my_pos, attention_pos)
							in_cone = my_fwd:angle(tmp_vec1) <= self._cone_angle * 0.5
						end
						if in_cone then
							detected_obj[u_key] = self:_create_detected_attention_object_data(t, u_key, attention_info, settings)
						end
					end
				end
			end
		end
	end
end
