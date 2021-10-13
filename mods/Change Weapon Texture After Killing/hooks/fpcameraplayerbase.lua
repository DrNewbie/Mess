local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local Hook3 = "F_"..Idstring("Hook3::"..ThisModIds):key()
local Func1 = "F_"..Idstring("Func1::"..ThisModIds):key()

Hooks:PostHook(FPCameraPlayerBase, "spawn_melee_item", Hook3, function(self)
	if self._melee_item_units then
		local __melee_entry = managers.blackmarket:equipped_melee_weapon()
		for __k, __melee_unit in pairs(self._melee_item_units) do
			managers.player[Func1](managers.player, __melee_unit, __melee_entry)
		end
	end
end)