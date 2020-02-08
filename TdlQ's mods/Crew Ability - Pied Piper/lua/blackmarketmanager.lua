local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

if not Network:is_server() then
	return
end

local capp_original_blackmarketmanager_init = BlackMarketManager.init
function BlackMarketManager:init()
	capp_original_blackmarketmanager_init(self)

	if self._global._selected_henchmen then
		for _, data in pairs(self._global._selected_henchmen) do
			data.capp_cable_ties_nr = CrewAbilityPiedPiper.extra_cable_ties
		end
	end
end
