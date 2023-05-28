local DeadManSysMain = _G.DeadManSysMain

if DeadManSysMain._hooks.on_player_dead then
	return
else
	DeadManSysMain._hooks.on_player_dead = true
end

if not DeadManSysMain._funcs.__IsHost() then
	return
end

Hooks:PostHook(TradeManager, "on_AI_criminal_death", DeadManSysMain.__Name("when dead 1"), function(self, __name, ...)
	if self:is_criminal_in_custody(__name) and not DeadManSysMain._funcs.IsThisCharacterDead(__name) then
		DeadManSysMain._funcs.SubThisCharacterLife(__name, 1)
	end
end)

Hooks:PostHook(TradeManager, "on_player_criminal_death", DeadManSysMain.__Name("when dead 2"), function(self, __name, ...)
	if self:is_criminal_in_custody(__name) and not DeadManSysMain._funcs.IsThisCharacterDead(__name) then
		DeadManSysMain._funcs.SubThisCharacterLife(__name, 1)
	end
end)