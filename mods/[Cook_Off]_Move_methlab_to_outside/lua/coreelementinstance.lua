if Network:is_client() then
	return
end

if not Global.game_settings or Global.game_settings.level_id ~= "rat" then
	return
end

core:module("CoreElementInstance")
core:import("CoreMissionScriptElement")
ElementInstanceInput = ElementInstanceInput or class(CoreMissionScriptElement.MissionScriptElement)

function ElementInstancePoint:_create()
	if self._has_created then
		return
	end
	self._has_created = true
	if Network:is_server() then
		self._mission_script:add_save_state_cb(self._id)
	end
	if self._values.instance then
		local _move_mathlab = {
			instance_point_methlab001 = true,
			instance_point_methlab002 = true,
			instance_point_methlab003 = true
		}
		if _move_mathlab[self._editor_name] then
			managers.world_instance:custom_create_instance(self._values.instance, {
				position = Vector3(2400.00, -30.00, 1124.84),
				rotation = Rotation(0.00, 0.00, 0.00)
			})
		else
			managers.world_instance:custom_create_instance(self._values.instance, {
				position = self._values.position,
				rotation = self._values.rotation
			})
		end
	elseif Application:editor() then
		managers.editor:output_error("[ElementInstancePoint:_create()] No instance defined in [" .. self._editor_name .. "]")
	end
end