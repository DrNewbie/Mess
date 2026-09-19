local ThisModPath = ModPath
local __Name = function(__id)
	return "ABC_"..Idstring(tostring(__id).."::"..ThisModPath):key()
end

local this_file = file

Hooks:PostHook(BlackMarketTweakData, "_init_projectiles", __Name(1), function(self)
	if this_file.DirectoryExists(ThisModPath.."sounds/") then
		for __id, __data in pairs(self.projectiles) do
			if type(__data) == "table" and type(__data.sounds) == "table" then
				if this_file.DirectoryExists(ThisModPath.."sounds/"..__id.."/") then
					if this_file.DirectoryExists(ThisModPath.."sounds/"..__id.."/activate/") then
						self.projectiles[__id].sounds.activate = nil
					end
					if this_file.DirectoryExists(ThisModPath.."sounds/"..__id.."/cooldown/") then
						self.projectiles[__id].sounds.cooldown = nil
					end
				end
			end
		end
	end
end)