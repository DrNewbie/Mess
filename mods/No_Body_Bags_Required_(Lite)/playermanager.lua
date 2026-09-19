Hooks:PostHook(PlayerManager, "_set_body_bags_amount", "NoBodyBagsRequiredLite", function(self)
	self._local_player_body_bags = self:max_body_bags() + 1
	managers.hud:on_ext_inventory_changed()
end)