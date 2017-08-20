if not ModCore then
	log("[ERROR][Holo] BeardLib is not installed!")
	return
end

ModCore:new(ModPath .. "Config.xml", false, true):init_modules()

Announcer:AddHostMod('Spawn More and Faster, (http://modwork.shop/20649)')