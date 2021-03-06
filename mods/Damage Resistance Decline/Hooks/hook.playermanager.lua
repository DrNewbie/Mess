local mod_ids = Idstring("Damage Resistance Decline"):key()
local func1 = "V_"..Idstring("func1::"..mod_ids):key()
local func2 = "V_"..Idstring("func2::"..mod_ids):key()

PlayerManager[func1] = PlayerManager[func1] or PlayerManager.damage_reduction_skill_multiplier

function PlayerManager:damage_reduction_skill_multiplier(...)
	local __Ans = self[func1](self, ...)
	if __Ans > 0 and __Ans < 1 then
		self[func2] = self[func2] or 0
		if TimerManager:game():time() > self[func2] then
			self[func2] = TimerManager:game():time() + 3
		else
			__Ans = 1 - (1 - __Ans) * 0.3
		end
	end
	return __Ans
end