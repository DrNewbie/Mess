local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local mvec3_ang = mvector3.angle
local mvec3_dir = mvector3.direction
local mvec3_dot = mvector3.dot
local mvec3_norm = mvector3.normalize
local mvec3_set = mvector3.set
local mvec3_set_static = mvector3.set_static
local mvec3_set_z = mvector3.set_z
local mvec3_sub = mvector3.subtract
local mvec3_x = mvector3.x
local mvec3_y = mvector3.y
local mvec3_z = mvector3.z
local mrot_y = mrotation.y

local nl_w_pos = Vector3()
local nl_pos = Vector3()
local nl_cam_forward = Vector3()
local tmp_vec1 = Vector3()

function HUDManager:_update_name_labels(t, dt)
	local viewport = managers.viewport
	local cam = viewport:get_current_camera()
	if not cam then
		return
	end
	local cam_pos = viewport:get_current_camera_position()
	local cam_rot = viewport:get_current_camera_rotation()
	mrot_y(cam_rot, nl_cam_forward)

	local player = managers.player:local_player()
	local mvt = player and player:alive() and player:movement()
	local in_steelsight = mvt and mvt:current_state() and mvt:current_state():in_steelsight()

	for _, data in ipairs(self._hud.name_labels) do
		local alpha

		local movement = data.movement
		if movement then
			mvec3_set(nl_w_pos, movement:m_pos())
			mvec3_set_z(nl_w_pos, mvec3_z(movement:m_head_pos()) + 30)
			if movement.current_state_name and movement:current_state_name() == 'driving' then
				alpha = 0
			elseif movement.vehicle_seat and movement.vehicle_seat.occupant ~= nil then
				alpha = 0
			end
		elseif data.vehicle then
			if not alive(data.vehicle) then
				return
			end
			local pos = data.vehicle:position()
			mvec3_set(nl_w_pos, pos)
			mvec3_set_z(nl_w_pos, mvec3_z(pos) + data.vehicle:vehicle_driving().hud_label_offset)
		end

		if not alpha then
			mvec3_dir(tmp_vec1, cam_pos, nl_w_pos)
			local angle = mvec3_ang(nl_cam_forward, tmp_vec1)
			if angle > 90 then
				alpha = 0
			elseif in_steelsight then
				--angle = angle / 8.11
				alpha = angle * angle * 0.0152
			else
				alpha = 1
			end
		end

		local label_panel = data.panel
		if alpha > 0 then
			mvec3_set(nl_pos, self._workspace:world_to_screen(cam, nl_w_pos))
			label_panel:set_center(mvec3_x(nl_pos), mvec3_y(nl_pos))
		end

		label_panel:set_alpha(alpha)
	end
end

local fs_original_hudmanager_addmugshotbyunit = HUDManager.add_mugshot_by_unit
function HUDManager:add_mugshot_by_unit(unit)
	if alive(unit) then
		return fs_original_hudmanager_addmugshotbyunit(self, unit)
	end
end

if MUIWaypoint then
	return
end

local wp_pos = Vector3()
local wp_dir_normalized = Vector3()
local wp_cam_forward = Vector3()
local wp_onscreen_direction = Vector3()
local wp_onscreen_target_pos = Vector3()
local hud_crosshair_offset_multiplier = tweak_data.scale.hud_crosshair_offset_multiplier

function HUDManager:_update_waypoints(t, dt)
	local viewport = managers.viewport
	local cam = viewport:get_current_camera()
	if not cam then
		return
	end

	local cam_pos = viewport:get_current_camera_position()
	local cam_rot = viewport:get_current_camera_rotation()
	mrot_y(cam_rot, wp_cam_forward)

	for id, data in pairs(self._hud.waypoints) do
		local data_distance = data.distance
		local data_timer_gui = data.timer_gui
		local data_bitmap = data.bitmap
		local data_state = data.state
		local panel = data_bitmap:parent()
		if data_state == 'sneak_present' then
			local panel_center_x, panel_center_y = panel:center()
			data.current_position = Vector3(panel_center_x, panel_center_y)
			data_bitmap:set_center(panel_center_x, panel_center_y)
			data.slot = nil
			data.current_scale = 1
			data.state = 'present_ended'
			data.text_alpha = 0.5
			data.in_timer = 0
			data.target_scale = 1
			if data_distance then
				data_distance:set_visible(true)
			end

		elseif data_state == 'present' then
			local panel_center_x, panel_center_y = panel:center()
			local cur_pos_x = panel_center_x + data.slot_x
			local cur_pos_y = panel_center_y + panel_center_y / 2
			data.current_position = Vector3(cur_pos_x, cur_pos_y)
			data_bitmap:set_center(cur_pos_x, cur_pos_y)
			data.text:set_center_x(cur_pos_x)
			data.text:set_top(data_bitmap:bottom())
			data.present_timer = data.present_timer - dt

			if data.present_timer <= 0 then
				data.slot = nil
				data.current_scale = 1
				data.state = 'present_ended'
				data.text_alpha = 0.5
				data.in_timer = 0
				data.target_scale = 1
				if data_distance then
					data_distance:set_visible(true)
				end
			end

		else
			local data_current_position = data.current_position
			if data.text_alpha ~= 0 then
				data.text_alpha = math.clamp(data.text_alpha - dt, 0, 1)
				data.text:set_color(data.text:color():with_alpha(data.text_alpha))
			end

			if data.unit then
				data.position = data.unit:position()
			end

			mvec3_set(wp_pos, self._saferect:world_to_screen(cam, data.position))

			local length = mvec3_dir(wp_dir_normalized, cam_pos, data.position)
			local dot = mvec3_dot(wp_cam_forward, wp_dir_normalized)

			if dot < 0 or panel:outside(mvec3_x(wp_pos), mvec3_y(wp_pos)) then
				if data_state ~= 'offscreen' then
					data.state = 'offscreen'
					data.arrow:set_visible(true)
					data_bitmap:set_color(data_bitmap:color():with_alpha(0.75))
					data.off_timer = 0 - (1 - data.in_timer)
					data.target_scale = 0.75

					if data_distance then
						data_distance:set_visible(false)
					end
					if data_timer_gui then
						data_timer_gui:set_visible(false)
					end
				end

				local direction = wp_onscreen_direction
				local panel_center_x, panel_center_y = panel:center()

				mvec3_set_static(direction, mvec3_x(wp_pos) - panel_center_x, mvec3_y(wp_pos) - panel_center_y, 0)
				mvec3_norm(direction)

				local dis = data.radius * hud_crosshair_offset_multiplier
				local target_pos = wp_onscreen_target_pos

				local direction_x = mvec3_x(direction)
				local direction_y = mvec3_y(direction)
				mvec3_set_static(target_pos, panel_center_x + direction_x * dis, panel_center_y + direction_y * dis, 0)

				if data.off_timer ~= 1 then
					data.off_timer = math.clamp(data.off_timer + dt / data.move_speed, 0, 1)
					mvec3_set(data_current_position, math.bezier({
						data_current_position,
						data_current_position,
						target_pos,
						target_pos
					}, data.off_timer))

					local current_scale = data.current_scale
					current_scale = math.bezier({
						current_scale,
						current_scale,
						data.target_scale,
						data.target_scale
					}, data.off_timer)
					data.current_scale = current_scale

					local size = data.size
					data_bitmap:set_size(mvec3_x(size) * current_scale, mvec3_y(size) * current_scale)
				else
					mvec3_set(data_current_position, target_pos)
				end

				local data_current_position_x = mvec3_x(data_current_position)
				local data_current_position_y = mvec3_y(data_current_position)
				data_bitmap:set_center(data_current_position_x, data_current_position_y)
				data.arrow:set_center(data_current_position_x + direction_x * 24, data_current_position_y + direction_y * 24)

				local angle = math.X:angle(direction) * math.sign(direction_y)
				data.arrow:set_rotation(angle)

				if data.text_alpha ~= 0 then
					data.text:set_center_x(data_bitmap:center_x())
					data.text:set_top(data_bitmap:bottom())
				end
			else
				if data_state == 'offscreen' then
					data.state = 'onscreen'
					data.arrow:set_visible(false)
					data_bitmap:set_color(data_bitmap:color():with_alpha(1))
					data.in_timer = 0 - (1 - data.off_timer)
					data.target_scale = 1
					if data_distance then
						data_distance:set_visible(true)
					end
					if data_timer_gui then
						data_timer_gui:set_visible(true)
					end
				end

				local alpha = 0.8
				if dot > 0.99 then
					alpha = math.clamp((1 - dot) / 0.01, 0.4, alpha)
				end

				local data_bitmap_color = data_bitmap:color()
				if math.abs(data_bitmap_color.alpha - alpha) > 0.0001 then
					data_bitmap_color = data_bitmap_color:with_alpha(alpha)
					data_bitmap:set_color(data_bitmap_color)
					if data_distance then
						data_distance:set_color(data_distance:color():with_alpha(alpha))
					end
					if data_timer_gui then
						data_timer_gui:set_color(data_bitmap_color)
					end
				end

				if data.in_timer ~= 1 then
					data.in_timer = math.clamp(data.in_timer + dt / data.move_speed, 0, 1)
					mvec3_set(data_current_position, math.bezier({
						data_current_position,
						data_current_position,
						wp_pos,
						wp_pos
					}, data.in_timer))
					data.current_scale = math.bezier({
						data.current_scale,
						data.current_scale,
						data.target_scale,
						data.target_scale
					}, data.in_timer)
					local size = data.size
					data_bitmap:set_size(mvec3_x(size) * data.current_scale, mvec3_y(size) * data.current_scale)
				else
					mvec3_set(data_current_position, wp_pos)
				end

				local bitmap_center_x = mvec3_x(data_current_position)
				data_bitmap:set_center(bitmap_center_x, mvec3_y(data_current_position))

				if data.text_alpha ~= 0 then
					data.text:set_center_x(bitmap_center_x)
					data.text:set_top(data_bitmap:bottom())
				end

				if data_distance then
					data_distance:set_text(string.format('%.0fm', length / 100))
					data_distance:set_center_x(bitmap_center_x)
					data_distance:set_top(data_bitmap:bottom())
				end
			end

			data.current_position = data_current_position
		end

		if data_timer_gui then
			data_timer_gui:set_center_x(data_bitmap:center_x())
			data_timer_gui:set_bottom(data_bitmap:top())

			if data.pause_timer == 0 then
				local data_timer = data.timer - dt
				data.timer = data_timer
				local text = data_timer < 0 and '00' or (math.round(data_timer) < 10 and '0' or '') .. math.round(data_timer)
				data_timer_gui:set_text(text)
			end
		end
	end
end
