Hooks:PreHook(FirstAidKitBase, 'take', 'F_'..Idstring('take:First aid kits expired'):key(), function(self, unit)
	if math.random() < 0.3 and not self._empty and unit and unit:character_damage() then
		unit:character_damage():delay_damage(100, 10)
		self:_set_empty()
		return
	end
end)