local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local redirects_nr = CopActionAct:_get_act_index(CopActionAct._act_redirects.SO[#CopActionAct._act_redirects.SO])

for _, entry in ipairs({'interact_enter', 'interact_exit'}) do
	if not table.contains(CopActionAct._act_redirects.SO, entry) then
		table.insert(CopActionAct._act_redirects.SO, entry)
	end
end

function CopActionAct:_sync_anim_play()
	if Network:is_server() then
		local action_desc = self._action_desc
		local action_index = self:_get_act_index(action_desc.variant)
		if action_index then
			local ext_network = self._common_data.ext_network
			local send_function = action_index > redirects_nr and ext_network.kpr_send or ext_network.send
			if action_desc.align_sync then
				local yaw = mrotation.yaw(self._common_data.rot)
				if yaw < 0 then
					yaw = 360 + yaw
				end

				local sync_yaw = 1 + math.ceil((yaw * 254) / 360)
				send_function(
					ext_network,
					'action_act_start_align',
					action_index,
					self._blocks.heavy_hurt and true or false,
					action_desc.clamp_to_graph or false,
					action_desc.needs_full_blend and true or false,
					sync_yaw,
					mvector3.copy(self._common_data.pos)
				)
			else
				send_function(
					ext_network,
					'action_act_start',
					action_index,
					self._blocks.heavy_hurt and true or false,
					action_desc.clamp_to_graph or false,
					action_desc.needs_full_blend and true or false
				)
			end
		else
			print('[CopActionAct:_sync_anim_play] redirect', action_desc.variant, 'not found')
		end
	end
end
