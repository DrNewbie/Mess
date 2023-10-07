local ThisModPath = ModPath

local __Name = function(__id)
	return "GGG_"..Idstring(tostring(__id).."::"..ThisModPath):key()
end

local __AllowCharacter = {
	bodhi = true
}

local function __GiveEffect(__unit)
	if __unit and alive(__unit) and type(__unit.effect_spawner) == "function" and __unit:effect_spawner(Idstring("burning_flames_001")) and __AllowCharacter[tostring(__unit:base():character_name())] then
		__unit:effect_spawner(Idstring("burning_flames_001")):set_enabled(true)
	end
	return
end

Hooks:PostHook(MenuSceneManager, "set_character", __Name(1), function(self, ...)
	pcall(__GiveEffect, self._character_unit)
end)

Hooks:PostHook(MenuSceneManager, "set_lobby_character_visible", __Name(2), function(self, __i, ...)
	pcall(__GiveEffect, self._lobby_characters[__i])
end)