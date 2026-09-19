Hooks:PostHook(GroupAITweakData, "_init_unit_categories", "ForcedLoadChangeBPH", function(self)
	for k, v in pairs(self.unit_categories or {}) do
		if v.unit_types and v.unit_types.murkywater then
			self.unit_categories[k].unit_types.zombie = {}
			self.unit_categories[k].unit_types.russia = {}
			self.unit_categories[k].unit_types.america = {}
			self.unit_categories[k].unit_types.zombie = deep_clone(v.unit_types.murkywater)
			self.unit_categories[k].unit_types.russia = deep_clone(v.unit_types.murkywater)
			self.unit_categories[k].unit_types.america = deep_clone(v.unit_types.murkywater)
		end
	end
end)