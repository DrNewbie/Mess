local _hts_PlayerDamage_damage_bullet = PlayerDamage.damage_bullet

function PlayerDamage:damage_bullet(attack_data)
	if not self:_chk_can_take_dmg() then
		return
	end
	if self._unit:inventory():check_shield_unit() and attack_data and attack_data.col_ray.position then
		local ply_camera = managers.player:player_unit():camera()
		local target_vec = attack_data.col_ray.position - ply_camera:position()
		local angle = target_vec:to_polar_with_reference(ply_camera:forward(), math.UP).spin
		if (90 <= angle and angle <= 180) or (-180 <= angle and angle <= -90) then
			attack_data.damage = 0.001
		end
	end
	_hts_PlayerDamage_damage_bullet(self, attack_data)
end