if ModCore then
	ModCore:new(ModPath .. "Config.xml", false, true):init_modules()
end

if Announcer then
	Announcer:AddHostMod('Spawn More and Faster, (http://modwork.shop/20649)')
end