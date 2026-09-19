local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local __Name = function(__id)
	return "ARwNS_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end

local Hook1 = __Name("_check_action_reload")
local Dt1 = __Name("Dt1")

Hooks:PostHook(PlayerStandard, "_update_foley", __Name("_update_foley"), function(self, __t, __input, ...)
	if self:_is_reloading() and (__input.btn_primary_attack_state or __input.btn_primary_attack_release) then
		self[Dt1] = nil
		self:_interupt_action_reload(__t)
	end
end)

PlayerStandard[Hook1] = PlayerStandard[Hook1] or PlayerStandard._check_action_reload

function PlayerStandard:_check_action_reload(__t, __input, ...)
	local __new_action = self[Hook1](self, __t, __input, ...)
	local __is_bool = false
	if not __new_action and not __input.btn_reload_press then
		local __action_forbidden = self:_is_reloading() or self:_changing_weapon() or self:_is_meleeing() or self._use_item_expire_t or self:_interacting() or self:_is_throwing_projectile()
		__action_forbidden = __action_forbidden or self:is_shooting_count()
		if not __action_forbidden and self._equipped_unit and not self._equipped_unit:base():clip_full() then
			__is_bool = true
			if self[Dt1] and self[Dt1] < __t then
				self[Dt1] = nil
				self:_start_action_reload_enter(__t)
			elseif not self[Dt1] then
				self[Dt1] = __t + 1
			else
				__is_bool = true
			end
		end
	end
	if not __is_bool then
		self[Dt1] = nil
	end
	return false
end