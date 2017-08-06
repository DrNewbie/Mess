Hooks:PostHook(WeaponFactoryTweakData, "init", "NATO_Minus", function(self, ...)
	if not self or not self.parts then
		return
	end
	local _unit = {}
	if true then
		for k, v in pairs(self.parts) do
			if v.type and v.unit then
				_unit[v.type] = _unit[v.type] or {}
				table.insert(_unit[v.type], v.unit)
			end
		end
		for k, v in pairs(self.parts) do
			if v.type and v.unit and _unit and _unit[v.type] then
				local _rn = table.size(_unit[v.type])
				local _rk = math.random(_rn)
				if _unit[v.type][_rk] then
					self.parts[k].unit = _unit[v.type][_rk]
				end
			end
		end
	else
		for k, v in pairs(self.parts) do
			if v.type and v.unit then
				table.insert(_unit, v.unit)
			end
		end
		for k, v in pairs(self.parts) do
			if v.type and v.unit and _unit then
				local _rn = table.size(_unit)
				local _rk = math.random(_rn)
				if _unit[_rk] then
					self.parts[k].unit = _unit[_rk]
					_unit[_rk] = nil
				end
			end
		end
	end
end )