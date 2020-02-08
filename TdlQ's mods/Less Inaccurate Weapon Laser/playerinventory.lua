local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local liwl_original_playerinventory_addunitbyfactoryname = PlayerInventory.add_unit_by_factory_name
function PlayerInventory:add_unit_by_factory_name(...)
	_G.liwl_is_local_player = true
	liwl_original_playerinventory_addunitbyfactoryname(self, ...)
	_G.liwl_is_local_player = nil
end
