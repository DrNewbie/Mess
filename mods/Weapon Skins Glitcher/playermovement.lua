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
					cosmetics.uv_offset_rot = Vector3(math.sin(135 * t + 0) / 2 + 0.5, math.sin(140 * t + 60) / 2 + 0.5, math.sin(145 * t + 120) / 2 + 0.5)
					cosmetics.uv_scale = Vector3((math.sin(135 * t + 0) / 2 + 0.5)*10, (math.sin(140 * t + 60) / 2 + 0.5)*10, (math.sin(145 * t + 120) / 2 + 0.5)*10)
					--cosmetics.base_gradient = base_gradient_list[math.random(base_gradient_list_size)]
					local y = 0
					if type(cosmetics.parts) == "table" then
						for f_id, d1 in pairs(cosmetics.parts) do
							y = y + 1
							if type(d1) == "table" then
								for mtr_id, _ in pairs(cosmetics.parts[f_id]) do
									y = y + 1
									angle = (r + math.tan(t * y + y)) * math.pi * t
									cosmetics.parts[f_id][mtr_id].uv_offset_rot = Vector3(math.sin(135 * t + 0) / 2 + 0.5, math.sin(140 * t + 60) / 2 + 0.5, math.sin(145 * t + 120) / 2 + 0.5)
									cosmetics.parts[f_id][mtr_id].uv_scale = Vector3((math.sin(135 * t + 0) / 2 + 0.5)*10, (math.sin(140 * t + 60) / 2 + 0.5)*10, (math.sin(145 * t + 120) / 2 + 0.5)*10)
									--cosmetics.parts[f_id][mtr_id].base_gradient = base_gradient_list[math.random(base_gradient_list_size)]
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