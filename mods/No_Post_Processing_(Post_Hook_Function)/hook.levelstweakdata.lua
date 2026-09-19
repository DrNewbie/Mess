--[[
Hooks:PostHook(LevelsTweakData, "init", "F_"..Idstring("PostHook:LevelsTweakData:init:No Post Processing (Post Hook Function):OwO"):key(), function(self)
	for _, entry_name in ipairs(self._level_index) do
		if self[entry_name] and self[entry_name].environment_effects then
			self[entry_name].environment_effects = {}
		end
	end
end)
]]