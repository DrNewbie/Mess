local ThisModPath = ModPath
local ThisModPathIds = Idstring(ThisModPath):key()
local Func1 = "F1_"..ThisModPathIds
local Func2 = "F2_"..ThisModPathIds
local Func3 = "F3_"..ThisModPathIds

local function __Say(__killed_unit)
	if managers.player:local_player() and CopDamage.is_civilian(__killed_unit:base()._tweak_table) then
		call_on_next_update(function()
			managers.player:local_player():sound():say("g24", true, true)
		end)
	end
	return
end

Hooks:Add("LocalizationManagerPostInit", Func1, function(...)
	pcall(function()
		DelayedCalls:Add(Func2, 5, function()
			Hooks:PostHook(PlayerManager, "on_killshot", Func3, function(self, __killed_unit, ...)
				pcall(__Say, __killed_unit)
			end)
		end)
	end)
end)