if not Global.game_settings or not Global.game_settings.level_id or not Global.game_settings.level_id == 'election_day_1' then
	return
end

_G.CodesHelper = _G.CodesHelper or {}

CodesHelper._CodesAns = CodesHelper._CodesAns or {}

Hooks:PostHook(DialogManager, 'queue_dialog', 'CodesHelper_Announce', function(self, id, params)
	if Global.game_settings.level_id == 'election_day_1' and type(CodesHelper._CodesAns) == 'table' and CodesHelper._CodesAns.Truck then
		if not CodesHelper._CodesAns.WP then
			CodesHelper._CodesAns.WP = true
			managers.hud:add_waypoint(
				'election_day_1_right_truck', {
				icon = 'equipment_vial',
				distance = true,
				position = CodesHelper._CodesAns.Truck,
				no_sync = true,
				present_timer = 0,
				state = 'present',
				radius = 50,
				color = Color.green,
				blend_mode = 'add'
			})
		elseif id == 'Play_pln_ed1_03' then
			CodesHelper._CodesAns.WP = nil
			CodesHelper._CodesAns.Truck = nil
			managers.hud:remove_waypoint('election_day_1_right_truck')
		end
	end
end)

function CodesHelper:Set_Codes(data)
	for i, d in pairs(data) do
		CodesHelper._CodesAns[i] = d
	end
end