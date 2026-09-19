local ThisModPath = ModPath
local ThisOGGPath = ThisModPath.."sounds/bruh0000.ogg"

if blt.xaudio and io.file_is_readable(ThisOGGPath) then
	blt.xaudio.setup()
else
	return
end

local mod_ids = Idstring(ThisModPath):key()
local hook1 = "F"..Idstring("hook1::"..mod_ids):key()
local hook2 = "F"..Idstring("hook2::"..mod_ids):key()
local msgr1 = "F"..Idstring("msgr1::"..mod_ids):key()

Hooks:PostHook(PlayerDamage, "init", hook1, function(self)
	managers.player:unregister_message(Message.OnPlayerDodge, msgr1)
	managers.player:register_message(Message.OnPlayerDodge, msgr1, function()
		XAudio.UnitSource:new(XAudio.PLAYER, XAudio.Buffer:new(ThisOGGPath)):set_volume(1)
	end)
end)

Hooks:PreHook(PlayerDamage, "pre_destroy", hook2, function(self)
	managers.player:unregister_message(Message.OnPlayerDodge, msgr1)
end)