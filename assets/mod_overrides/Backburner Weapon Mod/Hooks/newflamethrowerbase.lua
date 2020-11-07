Hooks:PostHook(NewFlamethrowerBase, "setup_default", "F_"..Idstring("BackBurnerFuncInit_setup_default"):key(), function(self)
	if type(self._blueprint) == "table" and table.contains(self._blueprint, "wpn_fps_backburner") then
		self._is_backburner = true
	end
end)