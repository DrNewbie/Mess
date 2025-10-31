if not ModCore then
	log("[ERROR] BeardLib is not installed!")
else
	ModCore:new(ModPath .. "Config.xml", false, true):init_modules()
end

if Announcer then
	Announcer:AddHostMod('Armor Skins Boosts, (http://modwork.shop/20721)')
end