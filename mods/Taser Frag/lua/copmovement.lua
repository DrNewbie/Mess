function CopMovement:add_tased_effect(t)
	local _nowtime = TimerManager:game():time()
	table.insert(self._special_tased_effect,
		{
			fade_kill = World:effect_manager():spawn({
							effect = Idstring("effects/payday2/particles/character/taser_hittarget"),
							position = self._m_pos,
							normal = self._m_rot:y()
						}),
			during = _nowtime + t
		}
	)
	table.insert(self._special_tased_effect,
		{
			fade_kill = World:effect_manager():spawn({
							effect = Idstring("effects/payday2/particles/character/taser_hittarget"),
							position = self._m_head_pos,
							normal = self._m_head_rot:y()
						}),
			during = _nowtime + t
		}
	)
	table.insert(self._special_tased_effect,
		{
			fade_kill = World:effect_manager():spawn({
							effect = Idstring("effects/payday2/particles/character/taser_hittarget"),
							position = self._m_pos + Vector3(0, 0, (self._m_head_pos.z - self._m_pos.z)/2),
							normal = self._m_head_rot:y()
						}),
			during = _nowtime + t
		}
	)
end

Hooks:PostHook(CopMovement, "update", "Tased_Effect_update", function(cop, ...)
	local _nowtime = TimerManager:game():time()
	cop._special_tased_effect = cop._special_tased_effect or {}
	for _id, _data in pairs(cop._special_tased_effect) do
		if _data.during and type(_data.during) == "number" then
			if _nowtime > _data.during and _data.fade_kill then
				World:effect_manager():fade_kill(_data.fade_kill)
				cop._special_tased_effect[_id] = nil
			end
		end
	end
end)