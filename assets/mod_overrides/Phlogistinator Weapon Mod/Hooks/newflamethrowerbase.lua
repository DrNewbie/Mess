local mod_ids = Idstring("Phlogistinator Weapon Mod"):key()
local is_mod = "F_"..Idstring("is_mod:"..mod_ids):key()
local func1 = "F_"..Idstring("func1:"..mod_ids):key()
local func5 = "F_"..Idstring("func5:"..mod_ids):key()
local func6 = "F_"..Idstring("func6:"..mod_ids):key()
local func7 = "F_"..Idstring("func7:"..mod_ids):key()

Hooks:PostHook(NewFlamethrowerBase, "setup_default", func1, function(self)
	if type(self._blueprint) == "table" and table.contains(self._blueprint, "wpn_fps_phlogistinator") then
		self[is_mod] = true
		self[func5] = 0
		self[func6] = false
		self[func7] = 0
	end
end)