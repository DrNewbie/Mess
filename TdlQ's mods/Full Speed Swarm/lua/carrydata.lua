local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local fs_original_carrydata_init = CarryData.init
function CarryData:init(unit)
	fs_original_carrydata_init(self, unit)
	if Network:is_client() or self._carry_id and not self:can_explode() then
		unit:set_extension_update_enabled(Idstring('carry_data'), false)
	end
end

local fs_original_carrydata_setpositionandthrow = CarryData.set_position_and_throw
function CarryData:set_position_and_throw(...)
	self._unit:set_extension_update_enabled(Idstring('carry_data'), true)
	self._unit:interaction():register_collision_callbacks()
	fs_original_carrydata_setpositionandthrow(self, ...)
end
