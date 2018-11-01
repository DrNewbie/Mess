function EnemyManager:get_nearby_medic(unit)
	if self:is_civilian(unit) then
		return nil
	end
	local enemies = World:find_units_quick(unit, "sphere", unit:position(), tweak_data.medic.radius, managers.slot:get_mask("enemies"))
	for _, enemy in ipairs(enemies) do
		if enemy:base():has_tag("medic") then
			return enemy
		end
	end
	enemies = World:find_units_quick(unit, "sphere", unit:position(), tweak_data.medic.radius * 2, managers.slot:get_mask("enemies"))
	for _, enemy in ipairs(enemies) do
		if enemy:base()._medictaser then
			return enemy
		end
	end
	return nil
end