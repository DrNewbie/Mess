local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local kpr_original_criminalsmanager_charactercoloridbyunit = CriminalsManager.character_color_id_by_unit
function CriminalsManager:character_color_id_by_unit(unit)
	local peer_id = unit:base() and unit:base().kpr_minion_owner_peer_id
	return peer_id or kpr_original_criminalsmanager_charactercoloridbyunit(self, unit) or 5
end
