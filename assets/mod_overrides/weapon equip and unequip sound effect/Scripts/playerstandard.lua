local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local Hook1 = "F_".. Idstring("Hook1::"..ThisModPath):key()
local Bool1 = "F_".. Idstring("Bool1::"..ThisModPath):key()
local Bool2 = "F_".. Idstring("Bool2::"..ThisModPath):key()

tweak_data.weapon.peacemaker.__weapon_pull_out_sound = "OGG_0FEE7FB3C7CD7F1C"
tweak_data.weapon.peacemaker.__weapon_put_in_sound = "OGG_3149341ED8825DFA"

Hooks:PostHook(PlayerStandard, "_update_equip_weapon_timers", Hook1, function(self)
	if self:_changing_weapon() and not self[Bool1] then
		self[Bool1] = true
	end
	if not self:_changing_weapon() and self[Bool1] then
		self[Bool1] = false
		if self._equipped_unit and alive(self._equipped_unit) and self._equipped_unit:base() then
			local pull_out_sound = self._equipped_unit:base():weapon_tweak_data().__weapon_pull_out_sound
			if pull_out_sound then
				self._unit:sound_source():post_event(pull_out_sound)
			end
		end
	end
	if self:_changing_weapon() and not self[Bool2] then
		self[Bool2] = true
		if self._equipped_unit and alive(self._equipped_unit) and self._equipped_unit:base() then
			local put_in_sound = self._equipped_unit:base():weapon_tweak_data().__weapon_put_in_sound
			if put_in_sound then
				self._unit:sound_source():post_event(put_in_sound)
			end
		end
	end
	if not self:_changing_weapon() and self[Bool2] then
		self[Bool2] = false
	end
end)