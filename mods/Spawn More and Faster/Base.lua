if not ModCore then
	log("[ERROR]'Spawn More and Faster' : BeardLib is not installed!")
	return
end

ModCore:new(ModPath .. "Config.xml", false, true):init_modules()

if Announcer then
	Announcer:AddHostMod('Spawn More and Faster, (http://modwork.shop/20649)')
end