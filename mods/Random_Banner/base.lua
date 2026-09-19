local ThisModPath = ModPath

local function __Name(__text)
	return "SSS_"..Idstring(tostring(__text)..ThisModPath):key()
end

if _G[__Name(1)] then
	return
else
	_G[__Name(1)] = true
end

Hooks:PreHook(NewHeistsGui, "init", __Name(2), function(self, ...)
	table.shuffle(tweak_data.gui.new_heists)
end)