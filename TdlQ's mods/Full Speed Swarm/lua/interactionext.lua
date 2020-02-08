local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

function BaseInteractionExt:can_select(player)
	if alive(player) then
		local mvt = player:movement()
		if mvt and mvt.current_state_name then
			local current_state_name = mvt:current_state_name()
			if not self:_has_required_upgrade(current_state_name) or not self:_is_in_required_state(current_state_name) then
				return false
			end
		end
	end

	if not self:_has_required_deployable() then
		return false
	end

	local seb = self._tweak_data.special_equipment_block
	if not seb then
		-- nothing
	elseif type(seb) == 'string' then
		if managers.player:has_special_equipment(seb) then
			return false
		end
	else
		for _, blocker in ipairs(seb) do
			if managers.player:has_special_equipment(blocker) then
				return false
			end
		end
	end

	if self._tweak_data.verify_owner and not self:is_owner() then
		return false
	end

	return true
end

local fs_original_carryinteractionext_collisioncallback = CarryInteractionExt._collision_callback
function CarryInteractionExt:_collision_callback(tag, unit, body, other_unit, ...)
	if unit:key() ~= other_unit:key() then
		if not unit:carry_data():can_explode() then
			unit:set_extension_update_enabled(Idstring('carry_data'), false)
		end
	end
	fs_original_carryinteractionext_collisioncallback(self, tag, unit, body, other_unit, ...)
end
