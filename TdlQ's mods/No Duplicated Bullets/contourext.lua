local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local ndb_original_contourext_add = ContourExt.add
function ContourExt:add(contour_type, sync, multiplier)
	if sync and contour_type == 'medic_heal' then
		if alive(self._unit) then
			local ucd = self._unit.character_damage and self._unit:character_damage()
			if type(ucd) == 'table' then
				ucd:ndb_reset_health()
			end
		end
	end

	return ndb_original_contourext_add(self, contour_type, sync, multiplier)
end
