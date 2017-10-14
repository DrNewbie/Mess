function GroupAIStateBase:_get_difficulty_dependent_value(tweak_values)
	return math.lerp(tweak_values[self._difficulty_point_index], tweak_values[self._difficulty_point_index + 1], self._difficulty_ramp)
end

function GroupAIStateBase:Forced_SMF_GUI_update()
	self._SMF_GUI_Enemy_Amount = 0
	self._SMF_GUI_Special_Amount = {}
	local _all_enemies = managers.enemy:all_enemies() or {}
	for _, data in pairs(_all_enemies) do
		if not managers.groupai:state():is_enemy_special(data.unit) then
			self._SMF_GUI_Enemy_Amount = self._SMF_GUI_Enemy_Amount + 1
		else
			local catname = tostring(data.unit:base()._tweak_table)
			self._SMF_GUI_Special_Amount[catname] = self._SMF_GUI_Special_Amount[catname] or 0
			self._SMF_GUI_Special_Amount[catname] = self._SMF_GUI_Special_Amount[catname] + 1
		end
	end
end

Hooks:PostHook(GroupAIStateBase, "update", "SMF_GUI_update", function(self, t,...)
	self._SMF_GUI_dealy_t = self._SMF_GUI_dealy_t or 0
	if t < self._SMF_GUI_dealy_t then
		return
	end
	self._SMF_GUI_dealy_t = t + 5
	self:Forced_SMF_GUI_update()
end)

function GroupAIStateBase:_SMF_GUI_Get_Special_Amount(catname)
	return self._SMF_GUI_Special_Amount[catname] or 0
end

function GroupAIStateBase:_SMF_GUI_Get_Enemy_Amount()
	return self._SMF_GUI_Enemy_Amount or 0
end