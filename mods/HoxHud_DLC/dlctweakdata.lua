Hooks:PostHook(DLCTweakData, "init", "F_"..Idstring("DLCTweakData:init:HoxHud DLC"):key(), function(self)
	self.hoxhud_group = {
		content = {},
		dlc = "has_hoxhud_group"
	}
end)