local _f_PlayerStandard_do_action_melee = PlayerStandard._do_action_melee

function PlayerStandard:_do_action_melee(t, ...)
	local _col_ray = self:_calc_melee_hit_ray(t, 20)
	if _col_ray and alive(_col_ray.unit) then
		local _pos = _col_ray.hit_position
		if _pos then
			World:effect_manager():spawn({
				effect = Idstring("effects/payday2/particles/explosions/flamethrower"),
				position = _pos,
				normal = math.UP
			})
		end
	end
	_f_PlayerStandard_do_action_melee(self, t, ...)
end