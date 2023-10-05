local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()

local __Name = function(__id)
	return "GGG_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end

local Hook0 = __Name("Hook0")
local Hook1 = __Name("Hook1")
local Hook2 = __Name("Hook2")
local Hook3 = __Name("Hook3")
local Old0 = __Name("Old0")
local Old1 = __Name("Old1")
local Old2 = __Name("Old2")
local Bool0 = __Name("Bool0")

_G.GuardianBonusBuff = _G.GuardianBonusBuff or {}

Hooks:PreHook(PlayerStandard, "_check_action_primary_attack", Hook0, function(self)
	local weap_base = self._equipped_unit:base()
	if weap_base and GuardianBonusBuff and GuardianBonusBuff.GetBonusPercent then
		if not weap_base[Old0] and type(weap_base["trigger_pressed"]) == "function" then
			weap_base[Old0] = weap_base.trigger_pressed
			weap_base.trigger_pressed = function (self, pos, dir, dmg_mul, ...)
				dmg_mul = dmg_mul + GuardianBonusBuff:GetBonusPercent("increase_addon_weapon_damage_multiplier")
				return self[Old0](self, pos, dir, dmg_mul, ...)
			end
		end
		if not weap_base[Old1] and type(weap_base["trigger_released"]) == "function" then
			weap_base[Old1] = weap_base.trigger_released
			weap_base.trigger_released = function (self, pos, dir, dmg_mul, ...)
				dmg_mul = dmg_mul + GuardianBonusBuff:GetBonusPercent("increase_addon_weapon_damage_multiplier")
				return self[Old1](self, pos, dir, dmg_mul, ...)
			end
		end
		if not weap_base[Old2] and type(weap_base["trigger_held"]) == "function" then
			weap_base[Old2] = weap_base.trigger_held
			weap_base.trigger_held = function (self, pos, dir, dmg_mul, ...)
				dmg_mul = dmg_mul + GuardianBonusBuff:GetBonusPercent("increase_addon_weapon_damage_multiplier")
				return self[Old2](self, pos, dir, dmg_mul, ...)
			end
		end
	end
end)

PlayerStandard[Hook1] = PlayerStandard[Hook1] or PlayerStandard._get_interaction_speed

function PlayerStandard:_get_interaction_speed(...)
	local __dt = self[Hook1](self, ...)
	if GuardianBonusBuff and GuardianBonusBuff.GetBonusPercent then
		local __var = 1 + GuardianBonusBuff:GetBonusPercent("increase_interaction_speed_multiplier")
		__dt = __dt * __var
	end
	return __dt
end

Hooks:PostHook(PlayerStandard, "_update_equip_weapon_timers", Hook2, function(self)
	if self._equipped_unit and alive(self._equipped_unit) and self._equipped_unit:base() and not self._equipped_unit:base()[Bool0] then
		self._equipped_unit:base()[Bool0] = true
		self._equipped_unit:base()[Hook3] = self._equipped_unit:base()[Hook3] or self._equipped_unit:base().reload_speed_multiplier
		self._equipped_unit:base().reload_speed_multiplier = function(them, ...)
			local __var = 1
			if GuardianBonusBuff and GuardianBonusBuff.GetBonusPercent then
				__var = 1 + GuardianBonusBuff:GetBonusPercent("increase_reload_speed_multiplier")
			end
			return them[Hook3](them, ...) * __var
		end
	end
end)