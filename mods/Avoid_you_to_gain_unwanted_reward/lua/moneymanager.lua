_G.EXPRewardLater = _G.EXPRewardLater or {}

local EXPRewardLater_add_to_total = MoneyManager._add_to_total

function MoneyManager:_add_to_total(amount, params)
	local no_offshore = params and params.no_offshore
	if not no_offshore or not 0 then
	end
	if EXPRewardLater.settings.SaveThisTime == 1 then 
		EXPRewardLater.settings.Total_Saved = amount
		amount = 0
	else
		amount = amount + EXPRewardLater.settings.Total_Saved
		EXPRewardLater.settings.Total_Saved = 0
	end
	EXPRewardLater:Save()
	return EXPRewardLater_add_to_total(self, amount, params)
end