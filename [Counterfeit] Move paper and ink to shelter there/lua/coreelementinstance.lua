if Network:is_client() then
	return
end

if not Global.game_settings or Global.game_settings.level_id ~= "pal" then
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
		local _move_paper = {
			paper_location001 = true,
			paper_location002 = true,
			paper_location003 = true,
			paper_location004 = true,
			paper_location005 = true
		}
		local _move_ink = {
			ink_location001 = true,
			ink_location002 = true,
			ink_location003 = true,
			ink_location004 = true,
			ink_location005 = true
		}
		if _move_paper[self._editor_name] then
			managers.world_instance:custom_create_instance(self._values.instance, {
				position = Vector3(-4590.00, 3330.00, -575.00),
				rotation = Rotation(-180.00, 0.00, -0.00)
			})
		elseif _move_ink[self._editor_name] then
			managers.world_instance:custom_create_instance(self._values.instance, {
				position = Vector3(-4337.00, 2730.00, -575.00),
				rotation = Rotation(-180.00, 0.00, -0.00)
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