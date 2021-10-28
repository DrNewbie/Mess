local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local Hook0 = "F_"..Idstring("PlayerDamage:init:"..ThisModIds):key()

Hooks:PostHook(PlayerDamage, "init", Hook0, function(self)
	Global.god_mode = false
end)