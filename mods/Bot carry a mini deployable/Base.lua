local ThisModPath = ModPath

if ModCore then
	ModCore:new(ThisModPath.."Config.xml", false, true):init_modules()
end