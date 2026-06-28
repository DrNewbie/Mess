Hooks:PostHook(EconomyTweakData, "init", "FakeOpenSafeFTweakDataInit", function(self)
	self.safes.fake_safe_1 = deep_clone(self.safes.event_01)
	self.safes.fake_safe_1.name_id = "bm_menu_safe_fakesafe_1_title"
	self.safes.fake_safe_1.addon = true
	self.safes.fake_safe_1.addon_safe_id = "fake_safe_1"
end)