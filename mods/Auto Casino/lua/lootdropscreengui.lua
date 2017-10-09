local _f_loot_update = LootDropScreenGui.update
function LootDropScreenGui:update(t, ...)
	_f_loot_update(self, t, ...)
	if not self._card_chosen then
		self:_set_selected_and_sync(math.random(3))
		self:confirm_pressed()
	end		
	if not self._button_not_clickable then
		self._auto_continue_t = self._auto_continue_t or (t + 1)
		if t >= self._auto_continue_t then
			self:continue_to_lobby()
		end
	end
end