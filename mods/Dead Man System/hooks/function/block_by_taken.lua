local DeadManSysMain = _G.DeadManSysMain

if DeadManSysMain._hooks.block_by_taken then
	return
else
	DeadManSysMain._hooks.block_by_taken = true
end

if not DeadManSysMain._funcs.__IsHost() then
	return
end

local old_is_character_as_AI_level_blocked = CriminalsManager.is_character_as_AI_level_blocked

function CriminalsManager:is_character_as_AI_level_blocked(__name, ...)
	if DeadManSysMain._funcs.IsThisCharacterDead(__name) then
		return true
	end
	return old_is_character_as_AI_level_blocked(self, __name, ...)
end

Hooks:PostHook(CriminalsManager, "_remove", DeadManSysMain.__Name("Remove:.taken"), function(self, __id, ...)
	if type(self._characters) == "table" then
		local __d = self._characters[__id]
		if type(__d) == "table" and DeadManSysMain._funcs.IsThisCharacterDead(__d.name) then
			self._characters[__id].taken = true
		end
	end
end)

Hooks:PostHook(CriminalsManager, "_create_characters", DeadManSysMain.__Name("Init:.taken"), function(self, ...)
	if type(self._characters) == "table" then
		local __c = self._characters
		for __i, __d in pairs(__c) do
			if type(__d) == "table" and DeadManSysMain._funcs.IsThisCharacterDead(__d.name) then
				self._characters[__i].taken = true
			end
		end
	end
end)