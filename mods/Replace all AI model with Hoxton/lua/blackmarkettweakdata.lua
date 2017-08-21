Hooks:PostHook(BlackMarketTweakData, "_init_characters", "BlackMarketTweakData_init_characters", function(bb, ...)
	local _dd = bb.characters.locked["old_hoxton"].sequence
	for k, v in pairs(bb.characters.locked) do
		if v and v.sequence then
			bb.characters.locked[k].sequence = _dd
		end
	end
	for k, v in pairs(bb.characters) do
		if v and v.sequence then
			bb.characters[k].sequence = _dd
			bb.characters[k].npc_unit = bb.characters.locked.npc_unit
		end
	end
end )