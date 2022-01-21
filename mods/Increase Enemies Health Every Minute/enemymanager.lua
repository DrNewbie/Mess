local ThisModPath = ModPath or tostring(math.random())
local ThisModIds = Idstring(ThisModPath):key()
local Func1 = "E_"..Idstring("Func1::"..ThisModIds):key()
local Func2 = "E_"..Idstring("Func2::"..ThisModIds):key()
local Func3 = "E_"..Idstring("Func3::"..ThisModIds):key()
local Func4 = 60
local Func5 = 10

Hooks:PostHook(EnemyManager, "update", Func1, function(self, t, dt)
	if self[Func2] and self[Func3] and tweak_data.character then
		self[Func2] = self[Func2] - dt
		if self[Func2] <= 0 then
			self[Func2] = Func4
			self[Func3] = self[Func3] + Func5
			local multiplier = 1 + self[Func3] / 100
			for i, character in pairs(tweak_data.character:enemy_list()) do
				if tweak_data.character[character] then
					tweak_data.character[character].HEALTH_INIT = tweak_data.character[character].HEALTH_INIT * multiplier
				end
			end
		end
	else
		self[Func2] = Func4
		self[Func3] = 0
	end
end)