local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

function HuskCopDamage:damage_bullet(attack_data)
	if self._dead or self._invulnerable then
		return
	end

	local attacker_unit = attack_data.attacker_unit
	if alive(attacker_unit) and attacker_unit:slot() == 2 then
		-- player-to-AI stays the same
		return HuskCopDamage.super.damage_bullet(self, attack_data)
	end

	return self:is_friendly_fire(attacker_unit) and 'friendly_fire' or nil
end
