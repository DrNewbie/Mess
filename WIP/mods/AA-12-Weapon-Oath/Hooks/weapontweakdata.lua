local ThisModPath = ModPath
local Hook1 = "WA_Addon_"..Idstring("WeaponTweakData:init::"..ThisModPath):key()

if blt.xaudio then
	blt.xaudio.setup()
end

Hooks:PostHook(WeaponTweakData, "init", Hook1, function(self)
	self["aa12"].__oath_data = {
		__max_points = 5*200000,
		__oath_link = function(is_click, now_rate)
			if blt.xaudio and is_click then
				local SoundsPath = ThisModPath.."Sounds/"
				local ThisOGGPaths = {
					SoundsPath.."AA12_FEED_JP.ogg",
					SoundsPath.."AA12_GAIN_JP.ogg",
					SoundsPath.."AA12_HELLO_JP.ogg",
					SoundsPath.."AA12_DIALOGUE1_JP.ogg",
					SoundsPath.."AA12_DIALOGUE2_JP.ogg",
					SoundsPath.."AA12_DIALOGUE3_JP.ogg"
				}
				if now_rate >= 100 then
					table.insert(ThisOGGPaths, SoundsPath.."AA12_DIALOGUEWEDDING_JP.ogg")
					table.insert(ThisOGGPaths, SoundsPath.."AA12_SOULCONTRACT_JP.ogg")
				end
				local UseThisOGG = table.random(ThisOGGPaths)
				if io.file_is_readable(UseThisOGG) then
					XAudio.Source:new(XAudio.Buffer:new(UseThisOGG))
				end
			end
		end
	}
end)