_G.FakeOpenSafeF = _G.FakeOpenSafeF or {}

FakeOpenSafeF.ModPath = FakeOpenSafeF.ModPath or ModPath

Hooks:Add("LocalizationManagerPostInit", "FakeOpenSafeF_loc", function(loc)
	loc:load_localization_file(FakeOpenSafeF.ModPath.."loc/en.json")
end)

local old_spawn_item_weapon = MenuSceneManager.spawn_item_weapon

function MenuSceneManager:spawn_item_weapon(...)
	local w_unit = old_spawn_item_weapon(self, ...)
	if w_unit and FakeOpenSafeF._MenuSceneManager_Ready then
		FakeOpenSafeF._MenuSceneManager_Ready = nil
		self = FakeOpenSafeF:HijackSafeAnsSpawn(self, w_unit)
		return
	end
	return w_unit
end

Hooks:PostHook(MenuSceneManager, "_create_safe_result", "FakeOpenSafeFOpenEnd", function(self)
	if FakeOpenSafeF then
		FakeOpenSafeF._MenuNodeEconomySafe_Ready = nil
		FakeOpenSafeF._MenuSceneManager_Ready = nil
		FakeOpenSafeF._RewardFunction_Ready = nil
	end
end)