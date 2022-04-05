local ThisModPath = ModPath
local ThisOGGPath = ThisModPath.."sounds/eric-andre-let-me-in.ogg"

if blt.xaudio and io.file_is_readable(ThisOGGPath) then
	Hooks:PreHook(MenuManager, "show_failed_joining_dialog", "F_"..Idstring("Tako?"):key(), function(self, peer, peer_id, reason, ...)
		XAudio.Source:new(XAudio.Buffer:new(ThisOGGPath))
	end)
end