local ThisModPath = ModPath
local ThisOGG = ThisModPath.."1019461439.ogg"

if blt.xaudio then
	blt.xaudio.setup()
else
	return
end

local __Name = function(__id)
	return "GG_"..Idstring(tostring(__id).."::"..ThisModPath):key()
end

local function __ply_ogg()
	if io.file_is_readable(ThisOGG) then
		XAudio.UnitSource:new(XAudio.PLAYER, XAudio.Buffer:new(ThisOGG)):set_volume(1)
	end
	return
end

require("lib/states/GameState")
GameOverState = GameOverState or class(MissionEndState)

Hooks:PostHook(GameOverState, "at_enter", __Name("1"), function(...)
	if DelayedCalls then
		DelayedCalls:Add(__Name("2"), 1, function()
			pcall(__ply_ogg)
		end)
	end
end)