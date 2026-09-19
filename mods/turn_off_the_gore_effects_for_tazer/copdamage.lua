local old1 = CopDamage._check_special_death_conditions

function CopDamage:_check_special_death_conditions(...)
	if tostring(self._unit:base()._tweak_table) == "taser" then
		return
	end
	return old1(self, ...)
end

local old2 = CopDamage._dismember_body_part

function CopDamage:_dismember_body_part(...)
	if tostring(self._unit:base()._tweak_table) == "taser" then
		return
	end
	return old2(self, ...)
end