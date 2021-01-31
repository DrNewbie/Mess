local mod_ids = Idstring("CircleSpin"):key()
local func1 = "F_"..Idstring("func1:0:"..mod_ids):key()

if HUDManager then
	Hooks:PostHook(HUDManager, "feed_heist_time", "F_"..Idstring("HUDManager:feed_heist_time:CircleSpin"):key(), function(self, __time)
		if self._teammate_panels[HUDManager.PLAYER_PANEL] then
			if not self[func1] then
				self[func1] = __time + 1
			elseif self[func1] > 0 and __time > self[func1] then
				self[func1] = -1
				self._teammate_panels[HUDManager.PLAYER_PANEL]:__reRun()
			end
		end
	end)
end