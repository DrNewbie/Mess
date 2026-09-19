local SawSafeModPath = ModPath

if ModCore then
	ModCore:new(SawSafeModPath.."Config.xml", false, true):init_modules()
end