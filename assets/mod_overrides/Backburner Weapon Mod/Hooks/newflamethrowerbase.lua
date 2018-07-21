Hooks:PostHook(NewFlamethrowerBase, "setup_default", "BackBurnerFuncInit", function(self)
	if type(self._blueprint) == "table" and table.contains(self._blueprint, "wpn_fps_backburner") then
		self._is_backburner = true
	end
end)