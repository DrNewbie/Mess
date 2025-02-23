local ThisModPath = tostring(ModPath)
local ThisModIds = Idstring(ThisModPath):key()

local __Name = function(__id)
	return "K_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end

if _G[__Name(101)] then return end
_G[__Name(101)] = true

Hooks:PostHook(PlayerDamage, "init", __Name(102), function(self)
	for __msg_name, __msg in pairs(Message) do
		managers.player:register_message(__msg, __Name(__msg_name), function(...)
			HudBattleAnnouncersNotification.queue_by_type(__msg_name)
		end)
	end
	HudBattleAnnouncersNotification.load_config()
end)

Hooks:PostHook(PlayerDamage, "pre_destroy", __Name(103), function(self)
	for _, __msg in pairs(Message) do
		managers.player:unregister_message(__msg, __Name(__msg))
	end
end)