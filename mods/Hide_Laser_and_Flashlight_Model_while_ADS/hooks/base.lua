local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local __Name = function(__id)
	return "HideLaFBwADS_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end

Hooks:PostHook(PlayerStandard, "update", __Name("PostHook:PlayerStandard:update"), function(self)
	if self._equipped_unit and alive(self._equipped_unit) then
		local on_off = not self:in_steelsight()
		local weapon = self._ext_inventory:equipped_unit()
		local wep_base = weapon:base()
		if wep_base:has_gadget() then
			local gadgets = wep_base._gadgets
			for __i, __id in pairs(gadgets) do
				local gadget = wep_base._parts[__id]
				if gadget and alive(gadget.unit) then
					gadget.unit:set_visible(on_off)
				end
			end
		end
	end
end)