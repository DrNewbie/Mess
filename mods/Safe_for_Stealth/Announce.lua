if not Network:is_server() then
	return
end

_G.Safe4Stealth = _G.Safe4Stealth or {}

Hooks:PostHook(HostNetworkSession, "chk_drop_in_peer", "WeaponKick_drop_in_peer", function(self, peer)
	Safe4Stealth:DoAnnounce(peer:id())
end)

Hooks:PostHook(HostNetworkSession, "on_peer_outfit_loaded", "WeaponKick_on_peer_outfit_loaded", function(self, peer)
	Safe4Stealth:DoAnnounce(peer:id())
end)