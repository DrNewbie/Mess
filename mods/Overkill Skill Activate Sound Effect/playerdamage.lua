local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local ThisModAssets = ModPath.."Assets/sounds/memes/skills/overkill/"
local Hook1 = "F_"..Idstring("Hook1::"..ThisModIds):key()
local Hook2 = "F_"..Idstring("Hook2::"..ThisModIds):key()
local Bool1 = "F_"..Idstring("Bool1::"..ThisModIds):key()
local Bool2 = "F_"..Idstring("Bool2::"..ThisModIds):key()

Hooks:PostHook(PlayerDamage, "init", Hook1, function(self, ...)
	if blt.xaudio then
		self[Bool1] = false
		self[Bool2] = true
		blt.xaudio.setup()
	end
end)

Hooks:PostHook(PlayerDamage, "update", Hook2, function(self, unit, t, dt, ...)
	if self[Bool2] and self[Bool1] ~= managers.player:has_activate_temporary_upgrade("temporary", "overkill_damage_multiplier") then
		self[Bool1] = managers.player:has_activate_temporary_upgrade("temporary", "overkill_damage_multiplier")
		if self[Bool1] then
			XAudio.Source:new(XAudio.Buffer:new(ThisModAssets.."saruei_overkill_skill_activate.ogg"))
		else
			XAudio.Source:new(XAudio.Buffer:new(ThisModAssets.."saruei_overkill_skill_end.ogg"))
		end
	end
end)