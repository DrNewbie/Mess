_G.EXPRewardLater = _G.EXPRewardLater or {}
EXPRewardLater.settings.SaveThisTime = EXPRewardLater.settings.SaveThisTime or 0
EXPRewardLater.settings.SaveThisTime = EXPRewardLater.settings.SaveThisTime == 1 and 0 or 1
EXPRewardLater:Save()
EXPRewardLater:Announce()