local _set_current_rank = ExperienceManager.set_current_rank
function ExperienceManager:set_current_rank(value)
	if value > 25 then
		value = 25
		self:reset()
		self:update_progress()
	end
	_set_current_rank(self, value)
end