_G.Rage_Special = _G.Rage_Special or {}
Rage_Special.ModPath = ModPath

if ModCore then
	ModCore:new(Rage_Special.ModPath .. "Config.xml", true, true)
end