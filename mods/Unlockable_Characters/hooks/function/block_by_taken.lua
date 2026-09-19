local UnlockableCharactersSys = _G.UnlockableCharactersSys

if UnlockableCharactersSys._hooks.block_by_taken then
	return
else
	UnlockableCharactersSys._hooks.block_by_taken = true
end

if not UnlockableCharactersSys._funcs.__IsHost() then
	return
end

if UnlockableCharactersSys._funcs.__IsTutorialHeists() then
	return
end

local old_is_character_as_AI_level_blocked = CriminalsManager.is_character_as_AI_level_blocked

function CriminalsManager:is_character_as_AI_level_blocked(__name, ...)
	if not UnlockableCharactersSys._funcs.__IsTutorialHeists() then
		if not UnlockableCharactersSys._funcs.IsThisCharacterUnLocked(__name) then
			return true
		end
	end
	return old_is_character_as_AI_level_blocked(self, __name, ...)
end

Hooks:PostHook(CriminalsManager, "_remove", UnlockableCharactersSys.__Name("Remove:.taken"), function(self, __id, ...)
	if not UnlockableCharactersSys._funcs.__IsTutorialHeists() then
		if type(self._characters) == "table" then
			local __d = self._characters[__id]
			if type(__d) == "table" and not UnlockableCharactersSys._funcs.IsThisCharacterUnLocked(__d.name) then
				self._characters[__id].taken = true
			end
		end
	end
end)

Hooks:PostHook(CriminalsManager, "_create_characters", UnlockableCharactersSys.__Name("Init:.taken"), function(self, ...)
	if not UnlockableCharactersSys._funcs.__IsTutorialHeists() then
		if type(self._characters) == "table" then
			local __c = self._characters
			for __i, __d in pairs(__c) do
				if type(__d) == "table" and not UnlockableCharactersSys._funcs.IsThisCharacterUnLocked(__d.name) then
					self._characters[__i].taken = true
				end
			end
		end
	end
end)