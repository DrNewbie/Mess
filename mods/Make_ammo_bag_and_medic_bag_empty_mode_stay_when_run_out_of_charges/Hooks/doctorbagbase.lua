function DoctorBagBase:_set_empty()
    self._empty = true
	self._unit:interaction():set_active(false, false)
	self:_set_visual_stage()
	if self._unit:damage():has_sequence("empty") then
		self._unit:damage():run_sequence_simple("empty")
	end
end