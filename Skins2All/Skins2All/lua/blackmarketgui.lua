_G.Skins2All = _G.Skins2All or {}
Skins2All.populate_weapon_cosmetics = false

local _skins2all_populate_weapon_cosmetics = BlackMarketGui.populate_weapon_cosmetics

function BlackMarketGui:populate_weapon_cosmetics(...)
	Skins2All.populate_weapon_cosmetics = true
	_skins2all_populate_weapon_cosmetics(self, ...)
	Skins2All.populate_weapon_cosmetics = false
end