local ThisModPath = ModPath or tostring(math.random())

Hooks:PostHook(BlackMarketTweakData, "_init_projectiles", "MOD1_"..Idstring(ThisModPath):key(), function(self)
	if file.DirectoryExists(ThisModPath.."assets/sounds") then
		for __id, __data in pairs(self.projectiles) do
			if type(__data) == "table" and type(__data.sounds) == "table" then
				if file.DirectoryExists(ThisModPath.."sounds/"..__id) then
					if file.DirectoryExists(ThisModPath.."sounds/"..__id.."/activate") then
						self.projectiles[__id].sounds.activate = nil
					end
					if file.DirectoryExists(ThisModPath.."sounds/"..__id.."/cooldown") then
						self.projectiles[__id].sounds.cooldown = nil
					end
				end
			end
		end
	end
end)