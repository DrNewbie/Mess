local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local Hook1 = "Hook_"..Idstring("Hook1::"..ThisModPath):key()
local Wear_Ids = Idstring("wear_tear_value")

Hooks:PostHook(PlayerStandard, "_check_action_primary_attack", Hook1, function(self)
	if self._equipped_unit then
		if self:_changing_weapon() or self:_is_meleeing() or self._use_item_expire_t or self:_interacting() or self:_is_throwing_projectile() or self._menu_closed_fire_cooldown > 0 then
		
		else		
			local __weap_base = self._equipped_unit:base()
			if type(__weap_base._materials) == "table" and __weap_base.get_ammo_ratio and __weap_base:get_ammo_ratio() then
				local __p1 = __weap_base:get_ammo_ratio() * 1.5 - 0.5
				for _, __materials in pairs(__weap_base._materials) do
					for _, __m in pairs(__materials) do
						if __m:variable_exists(Wear_Ids) then
							local __p2 = __m:get_variable(Wear_Ids)
							local __p3 = __p2 - __p1
							if __p3 > 0 then
								__m:set_variable(Wear_Ids, __p2 - 0.0008)
							elseif __p3 < 0 then
								__m:set_variable(Wear_Ids, __p2 + 0.0008)
							end
						end
					end
				end
			end
		end
	end
end)