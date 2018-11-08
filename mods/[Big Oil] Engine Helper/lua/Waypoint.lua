if not Global.game_settings or Global.game_settings.level_id ~= "welcome_to_the_jungle_2" then
	return
end

_G.EngineHelper = _G.EngineHelper or {}

function EngineHelper:_set_waypoint()
	if EngineHelper.CorrectOne then
		self:_add_waypoint('CorrectOne', EngineHelper.CorrectOne)
	end
end

function EngineHelper:_add_waypoint(name, position)
	if name and position then
		self:_remove_waypoint(name)
		managers.hud:add_waypoint(
			'EngineHelperWaypoint_ThisOne_' .. name, {
			icon = 'equipment_vial',
			distance = true,
			position = position,
			no_sync = true,
			present_timer = 0,
			state = "present",
			radius = 50,
			color = Color.green,
			blend_mode = "add"
		})
	end
end

function EngineHelper:_remove_waypoint(id)
	managers.hud:remove_waypoint("EngineHelperWaypoint_ThisOne_" .. id)
end