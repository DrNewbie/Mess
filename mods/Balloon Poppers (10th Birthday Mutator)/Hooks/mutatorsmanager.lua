--[[
local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local Hook0 = "F_"..Idstring("MutatorsManager:init:"..ThisModIds):key()

dofile(ThisModPath.."Hooks/mutatorbirthday.lua")

Hooks:PostHook(MutatorsManager, "init", Hook0, function(self)
	table.insert(self._mutators, MutatorBirthday:new(self))
end)
]]