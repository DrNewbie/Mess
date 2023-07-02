local ThisModPath = ModPath

local function __Say(__killed_unit)
	if managers.player:local_player() and CopDamage.is_civilian(__killed_unit:base()._tweak_table) then
		call_on_next_update(function()
			managers.player:local_player():sound():say("g24", true, true)
		end)
	end
	return
end

Hooks:PostHook(PlayerManager, "on_killshot", "F_"..Idstring(ThisModPath):key(), function(self, __killed_unit, ...)
	pcall(__Say, __killed_unit)
end)