local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local ThisOGGAssets = ModPath.."Assets/sounds/birthday_buff/buff_birthday_2x_damage.ogg"
local Hook1 = "F_"..Idstring("Hook1::"..ThisModIds):key()
local IsOK = false

if blt.xaudio and io.file_is_readable(ThisOGGAssets) then
	blt.xaudio.setup()
	IsOK = true
end

Hooks:PostHook(PlayerManager, "activate_temporary_property", Hook1, function(self, __name, __time, __value)
	if IsOK and __name and __name == "birthday_multiplier" and __time and __time > 0 and __value and __value > 1 then
		XAudio.Source:new(XAudio.Buffer:new(ThisOGGAssets))
	end
end)