Hooks:PostHook(LootDropScreenGui, "update", "AutoCasino_LootDropScreenGui", function(self, t)
	if not self._card_chosen then
		self:_set_selected_and_sync(math.random(3))
		self:confirm_pressed()
	end		
	if not self._button_not_clickable then
		self._AutoCasino_t = self._AutoCasino_t or (t + 1)
		if t >= self._AutoCasino_t then
			self:continue_to_lobby()
		end
	end
end)