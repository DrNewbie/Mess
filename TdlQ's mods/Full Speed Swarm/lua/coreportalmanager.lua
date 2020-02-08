local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

core:module('CorePortalManager')

local table_remove = table.remove

function PortalUnitGroup:inside(pos)
	local shapes = self._shapes
	local nr = #shapes
	for i = 1, nr do
		if shapes[i]:is_inside(pos) then
			return true
		end
	end
	return false
end

function PortalUnitGroup:update(t, dt)
	local is_inside = false

	local positions = managers.portal:check_positions()
	local nr = #positions
	for i = 1, nr do
		is_inside = self:inside(positions[i])
		if is_inside then
			break
		end
	end

	if self._is_inside ~= is_inside then
		self._is_inside = is_inside
		local diff = self._is_inside and 1 or -1
		self:_change_units_visibility(diff)
	end
end

function PortalManager:render()
	local tw = TimerManager:wall()
	local t = tw:time()
	local dt =  tw:delta_time()

	local portal_shapes = self._portal_shapes
	local nr = #portal_shapes
	for i = 1, nr do
		portal_shapes[i]:update(t, dt)
	end

	for _, group in pairs(self._unit_groups) do
		group:update(t, dt)
	end

	local unit_id, unit = next(self._hide_list)
	if alive(unit) then
		unit:set_visible(false)
		self._hide_list[unit_id] = nil
	end

	while table_remove(self._check_positions) do
	end
end

function PortalUnitGroup:_change_visibility(unit, diff)
	if alive(unit) then
		local unit_data = unit:unit_data()
		if type(unit_data) == 'table' then
			local vc = unit_data._visibility_counter
			if vc then
				vc = vc + diff
			else
				vc = diff > 0 and 1 or 0
			end
			unit_data._visibility_counter = vc

			if vc > 0 then
				unit:set_visible(true)
				managers.portal:remove_from_hide_list(unit)
			else
				managers.portal:add_to_hide_list(unit)
			end
		end
	end
end
