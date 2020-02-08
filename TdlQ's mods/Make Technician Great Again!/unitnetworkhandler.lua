local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local mtga_original_unitnetworkhandler_lootlink = UnitNetworkHandler.loot_link
function UnitNetworkHandler:loot_link(loot_unit, parent_unit, sender)
	if not alive(loot_unit) or not alive(parent_unit) or not self._verify_gamestate(self._gamestate_filter.any_ingame) then
		return
	end

	local loot_unit_base = loot_unit:base()
	if loot_unit_base and loot_unit_base.is_drill then
		if loot_unit:key() == parent_unit:key() then
			mtga_unlink_drill(loot_unit)
		else
			mtga_link_drill_to_bulldo(parent_unit, loot_unit)
		end
		return
	end

	mtga_original_unitnetworkhandler_lootlink(self, loot_unit, parent_unit, sender)
end

