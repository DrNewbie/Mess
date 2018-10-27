function CopBrain:is_hostile()
	return self._current_logic_name ~= "intimidated"
end