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
			local __ans = nil
			if managers.player and managers.player:local_player() then
				local __equipped_weapon_unit = managers.player:equipped_weapon_unit()
				if __equipped_weapon_unit then
					local weapon = __equipped_weapon_unit:base()
					__ans = __ans and true or HudBattleAnnouncersNotification.queue_by_type_and_weapon(__msg_name, weapon._name_id)
					log("weapon._name_id:\t", tostring(weapon._name_id), tostring(__ans))
				end
			end
			if not __ans then
				__ans = HudBattleAnnouncersNotification.queue_by_type(__msg_name)
			end
		end)
	end
	HudBattleAnnouncersNotification.load_config()
end)

Hooks:PostHook(PlayerDamage, "pre_destroy", __Name(103), function(self)
	for _, __msg in pairs(Message) do
		managers.player:unregister_message(__msg, __Name(__msg))
	end
end)