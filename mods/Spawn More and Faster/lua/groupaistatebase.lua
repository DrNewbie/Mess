function GroupAIStateBase:_get_difficulty_dependent_value(tweak_values)
	return math.lerp(tweak_values[self._difficulty_point_index], tweak_values[self._difficulty_point_index + 1], self._difficulty_ramp)
end

function GroupAIStateBase:set_difficulty()
	self._difficulty_value = 1
	self:_calculate_difficulty_ratio()
end