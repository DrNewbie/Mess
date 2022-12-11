if not ModCore then
	log("[ERROR] BeardLib is not installed!")
	return
end

ModCore:new(ModPath .. "config.xml", true, true):init_modules()

Announcer:AddHostMod('Taser Frag, (https://modworkshop.net/mod/19484)')