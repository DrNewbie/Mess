_G.FakeOpenSafeF = _G.FakeOpenSafeF or {}

Hooks:PostHook(MenuCallbackHandler, "_safe_result_recieved", "FakeOpenSafeFOpenNow", function(self)
	if FakeOpenSafeF and FakeOpenSafeF._RewardFunction_Ready and FakeOpenSafeF._RewardFunction_Ready.Ans_Data then
		local _data = FakeOpenSafeF._RewardFunction_Ready.Ans_Data
		if _data.reward_fuction and self[_data.reward_fuction] then
			self[_data.reward_fuction](self, FakeOpenSafeF._safe_entry, _data)
		end
	end
end)