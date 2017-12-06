_G.WeaponKicker = _G.WeaponKicker or {}

Hooks:PostHook(HostNetworkSession, "chk_drop_in_peer", "WeaponKick_drop_in_peer", function(self, peer)
	WeaponKicker:DoAnnounce(peer:id())
end)

Hooks:PostHook(HostNetworkSession, "on_peer_outfit_loaded", "WeaponKick_on_peer_outfit_loaded", function(self, peer)
	WeaponKicker:DoAnnounce(peer:id())
end)