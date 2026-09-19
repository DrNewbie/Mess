local DrillEqualizer_ModPath = ModPath

if ModCore then
	ModCore:new(DrillEqualizer_ModPath.."Config.xml", false, true):init_modules()
end