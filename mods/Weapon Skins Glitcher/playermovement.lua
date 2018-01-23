local Skins_delay = 0
local tmp_vec1 = Vector3()
local tmp_vec2 = Vector3()

local tmp_vec_x = function(v1, v2, v3)
	return math.sin(v3 * v1 + v2) / 2 + 0.5
end
local tmp_vec_y = function(v1, v2, v3)
	return math.cos(v3 * v1 + v2) / 2 + 0.5
end
local tmp_vec_z = function(v1, v2, v3)
	return math.sin(v3 * v1 + v2) + 0.5
end

Hooks:PostHook(PlayerMovement, "update", "Skins_update", function(self, unit, t)
	if t > Skins_delay and self._unit:inventory() then
		Skins_delay = t + 0.1
		--[[
		local base_gradient_list = {}
		for i_sel, selection_data in pairs(self._unit:inventory()._available_selections) do
			if selection_data.unit and alive(selection_data.unit) and selection_data.unit:base() then
				local unit = selection_data.unit:base()
				local cosmetics = unit._cosmetics_id and tweak_data.blackmarket.weapon_skins[unit._cosmetics_id]
				if cosmetics then
					if cosmetics.base_gradient then
						base_gradient_list[cosmetics.base_gradient:key()] = cosmetics.base_gradient
					end
					if type(cosmetics.parts) == "table" then
						for f_id, d1 in pairs(cosmetics.parts) do
							if type(d1) == "table" then
								for mtr_id, _ in pairs(cosmetics.parts[f_id]) do
									if cosmetics.parts[f_id][mtr_id].base_gradient then
										base_gradient_list[cosmetics.parts[f_id][mtr_id].base_gradient:key()] = cosmetics.parts[f_id][mtr_id].base_gradient
									end
								end
							end
						end
					end
				end
			end
		end
		]]
		--local base_gradient_list_size = table.size(base_gradient_list)
		for i_sel, selection_data in pairs(self._unit:inventory()._available_selections) do
			if selection_data.unit and alive(selection_data.unit) and selection_data.unit:base() then
				local unit = selection_data.unit:base()
				local cosmetics = unit._cosmetics_id and tweak_data.blackmarket.weapon_skins[unit._cosmetics_id]
				if cosmetics then
					local r = math.random()
					local angle = r * math.pi * t
					cosmetics.uv_offset_rot = Vector3(tmp_vec_x(t, 37, 97), tmp_vec_y(t, 97, 37), tmp_vec_y(t, 97, 137))
					cosmetics.uv_scale = Vector3(tmp_vec_x(t, 37, 97)*10, tmp_vec_y(t, 97, 37)*10, tmp_vec_y(t, 97, 137)*10)
					--[[
					if cosmetics.base_gradient then
						cosmetics.base_gradient = base_gradient_list[math.random(base_gradient_list_size)]
					end
					]]
					if not cosmetics.pattern_tweak then
						cosmetics.pattern_tweak = Vector3(tmp_vec_x(t, 47, 97), tmp_vec_y(t, 47, 37), tmp_vec_y(t, 97, 229))
					end
					if not cosmetics.pattern_pos then
						cosmetics.pattern_pos = Vector3(tmp_vec_x(t, 113, 97), tmp_vec_y(t, 193, 37), tmp_vec_y(t, 281, 229))
					end
					local y = 0
					if type(cosmetics.parts) == "table" then
						for f_id, d1 in pairs(cosmetics.parts) do
							y = y + 1
							if type(d1) == "table" then
								for mtr_id, _ in pairs(cosmetics.parts[f_id]) do
									y = y + 1
									angle = (r + math.tan(t * y + y)) * math.pi * t
									cosmetics.parts[f_id][mtr_id].uv_offset_rot = Vector3(tmp_vec_x(t, 37, 97), tmp_vec_y(t, 97, 37), tmp_vec_y(t, 97, 137))
									cosmetics.parts[f_id][mtr_id].uv_scale = Vector3(tmp_vec_x(t, 37, 97)*10, tmp_vec_y(t, 97, 37)*10, tmp_vec_y(t, 97, 137)*10)
									--[[
									if cosmetics.parts[f_id][mtr_id].base_gradient then
										cosmetics.parts[f_id][mtr_id].base_gradient = base_gradient_list[math.random(base_gradient_list_size)]
									end
									]]
									if not cosmetics.parts[f_id][mtr_id].pattern_tweak then
										cosmetics.parts[f_id][mtr_id].pattern_tweak = Vector3(tmp_vec_x(t, 47, 97), tmp_vec_y(t, 47, 37), tmp_vec_y(t, 97, 229))
									end
									if not cosmetics.parts[f_id][mtr_id].pattern_pos then
										cosmetics.parts[f_id][mtr_id].pattern_pos = Vector3(tmp_vec_x(t, 113, 97), tmp_vec_y(t, 193, 37), tmp_vec_y(t, 281, 229))
									end
								end
							end
						end
					end
					unit._cosmetics_data = cosmetics
					unit:_apply_cosmetics(function()
					end)
				end
			end
		end
	end
end)