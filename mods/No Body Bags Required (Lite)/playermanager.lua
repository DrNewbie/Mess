function PlayerManager:_set_body_bags_amount(body_bags_amount)
	self._local_player_body_bags = self:max_body_bags() + 1
end