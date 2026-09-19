local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local __Name = function(__id)
	return "OFFLaFwADS_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end

local Bool1 = __Name("Bool1")
local Bool2 = __Name("Bool2")

Hooks:PostHook(PlayerStandard, "init", __Name("PostHook:PlayerStandard:init"), function(self)
	self[Bool1] = false
	self[Bool2] = {}
end)

Hooks:PostHook(PlayerStandard, "_start_action_steelsight", __Name("PostHook:PlayerStandard:_start_action_steelsight"), function(self)
	if self._equipped_unit and alive(self._equipped_unit) then
		if self[Bool1] ~= self:in_steelsight() then
			self[Bool1] = self:in_steelsight()
			local weapon = self._ext_inventory:equipped_unit()
			local wep_base = weapon:base()
			if wep_base:has_gadget() and wep_base:is_gadget_on() then
				local wep_key = weapon:key()
				self[Bool2][wep_key] = true
				wep_base:gadget_off()
			end
		end
	end
end)

Hooks:PostHook(PlayerStandard, "_end_action_steelsight", __Name("PostHook:PlayerStandard:_end_action_steelsight"), function(self)
	if self._equipped_unit and alive(self._equipped_unit) then
		if self[Bool1] ~= self:in_steelsight() then
			self[Bool1] = self:in_steelsight()
			local weapon = self._ext_inventory:equipped_unit()
			local wep_base = weapon:base()
			local wep_key = weapon:key()
			if wep_base:has_gadget() and self[Bool2][wep_key] then
				self[Bool2][wep_key] = nil
				wep_base:gadget_on()
			end
		end
	end
end)