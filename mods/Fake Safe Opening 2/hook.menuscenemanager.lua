_G.FakeOpenSafeF = _G.FakeOpenSafeF or {}

FakeOpenSafeF.ModPath = FakeOpenSafeF.ModPath or ModPath

Hooks:Add("LocalizationManagerPostInit", "FakeOpenSafeF_loc", function(loc)
	loc:load_localization_file(FakeOpenSafeF.ModPath.."Loc.json")
end)

local old_spawn_item_weapon = MenuSceneManager.spawn_item_weapon

function MenuSceneManager:spawn_item_weapon(...)
	local w_unit = old_spawn_item_weapon(self, ...)
	if w_unit and self._fake_safe_ids then
		self = FakeOpenSafeF:HijackSafeAnsSpawn(self, w_unit)
		return
	end
	return w_unit
end