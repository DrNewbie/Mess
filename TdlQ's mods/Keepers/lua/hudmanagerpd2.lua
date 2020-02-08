local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local kpr_original_hudmanager_addnamelabel = HUDManager._add_name_label
function HUDManager:_add_name_label(data)
	local u_mov = data.unit:movement()
	for _, label in ipairs(self._hud.name_labels) do
		if label.movement == u_mov then
			self:_remove_name_label(label.id)
			break
		end
	end

	return kpr_original_hudmanager_addnamelabel(self, data)
end

function HUDManager:kpr_set_interaction_circle(container, enabled)
	local player_panel = container._player_panel
	if not alive(player_panel) then
		return
	end

	local interact_panel = player_panel:child('interact_panel') or container._interact and container._interact._panel
	if not interact_panel then
		return
	end

	if player_panel:alpha() == 0 then
		player_panel:set_alpha(enabled and 1 or 0)
		for _, child in pairs(player_panel:children()) do
			child:set_alpha(enabled and child == interact_panel and 1 or 0)
		end
	else
		interact_panel:set_alpha(enabled and 1 or 0)
	end

	player_panel:child('radial_health_panel'):set_alpha(0)
end

function HUDManager:kpr_teammate_progress(packed_data, enabled, timer, success)
	local chunks = packed_data:split(';')
	local bot_name = chunks[2]
	local tweak_data_id = chunks[3]
	local hidden_weapon = chunks[4]

	local bot_unit = managers.criminals:character_unit_by_name(bot_name)
	if not alive(bot_unit) then
		return
	end
	local panel_id = bot_unit:unit_data().name_label_id
	local mugshot_id = bot_unit:unit_data().mugshot_id

	local name_label = self:_get_name_label(panel_id)
	if name_label then
		local icon = name_label.movement._unit:base().kpr_icon
		icon = enabled and (icon == Keepers.icons.revive and 'interaction_help' or icon) or 'mugshot_normal'
		self:_set_mugshot_state(mugshot_id, icon, '')

		name_label.interact:set_visible(enabled)
		local action = name_label.panel:child('action')
		if alive(action) then
			action:set_visible(enabled)
			local action_text = managers.localization:text(tweak_data.interaction[tweak_data_id].action_text_id or 'hud_action_generic')
			action:set_text(utf8.to_upper(action_text))
		end
		name_label.panel:stop()

		if name_label.set_action_progress then -- MUI
			name_label:set_action_progress(1, enabled, tweak_data_id, timer, success)
			if enabled and name_label.panel:child('infamy') then
				name_label.panel:child('infamy'):set_center(name_label.interact:center())
			end
		elseif enabled and name_label.interact then
			name_label.panel:animate(callback(self, self, '_animate_label_interact'), name_label.interact, timer)
			if name_label.panel:child('infamy') and name_label.interact._circle then
				name_label.panel:child('infamy'):set_center(name_label.interact._circle:center())
			end
		end
	end

	local teammate_panel = panel_id and self._teammate_panels[panel_id]
	if teammate_panel then
		teammate_panel:teammate_progress(enabled, tweak_data_id, timer, success)
		self:kpr_set_interaction_circle(teammate_panel, enabled)
	end

	if hidden_weapon then
		if enabled then
			bot_unit:inventory():hide_equipped_unit()
		else
			bot_unit:inventory():show_equipped_unit()
		end
	end
end
