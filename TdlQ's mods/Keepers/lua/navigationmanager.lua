local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local kpr_original_navigationmanager_registercoverunits = NavigationManager.register_cover_units
function NavigationManager:register_cover_units()
	local _debug = self._debug
	self._debug = true
	kpr_original_navigationmanager_registercoverunits(self)
	local covers = {}
	for _, cover in ipairs(self._covers) do
		table.insert(covers, cover[1])
	end
	Keepers._covers = covers
	self._debug = _debug
end
