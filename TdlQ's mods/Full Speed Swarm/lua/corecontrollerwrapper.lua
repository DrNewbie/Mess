local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

core:module("CoreControllerWrapper")

local empty_dummy = {}

function ControllerWrapper:get_all_input_down()
	return self._enabled and self._virtual_controller and self._virtual_controller:down_list() or empty_dummy
end

function ControllerWrapper:get_all_input_pressed()
	return self._enabled and self._virtual_controller and self._virtual_controller:pressed_list() or empty_dummy
end

function ControllerWrapper:get_all_input_released()
	return self._enabled and self._virtual_controller and self._virtual_controller:released_list() or empty_dummy
end

function ControllerWrapper:get_all_input_pdr()
	if self._enabled then
		local vc = self._virtual_controller
		if vc then
			return vc:pressed_list(), vc:down_list(), vc:released_list()
		end
	end

	return empty_dummy, empty_dummy, empty_dummy
end

local mvec3_x = mvector3.x
local mvec3_y = mvector3.y
local mvec3_z = mvector3.z
local mvec3_set_static = mvector3.set_static
function ControllerWrapper:get_modified_axis(connection_name, connection, axis)
	local mul_x, mul_y, mul_z = connection:fs_get_multiplier()
	if mul_x then
		mvec3_set_static(axis, mvec3_x(axis) * mul_x, mvec3_y(axis) * mul_y, mvec3_z(axis) * mul_z)
	end

	local inv_x, inv_y, inv_z = connection:fs_get_inversion()
	if inv_x then
		mvec3_set_static(axis, mvec3_x(axis) * inv_x, mvec3_y(axis) * inv_y, mvec3_z(axis) * inv_z)
	end

	return self:lerp_axis(connection_name, connection, axis)
end
