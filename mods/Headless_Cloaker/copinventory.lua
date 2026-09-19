local _f_add_unit_by_name = CopInventory.add_unit_by_name
function CopInventory:add_unit_by_name(...)
	_f_add_unit_by_name(self, ...)
	if self._unit:base()._tweak_table == "spooc" and self._unit:damage() then
		if self._unit:damage():has_sequence("dismember_head") then
			self._unit:damage():run_sequence_simple("dismember_head")
		end
	end
end