local _f_PlayerStandard_do_action_melee = PlayerStandard._do_action_melee

function PlayerStandard:_do_action_melee(t, ...)
	local _col_ray = self:_calc_melee_hit_ray(t, 20)
	local _player = managers.player:player_unit()
	if _col_ray and alive(_col_ray.unit) and _player and alive(_player) then
		local _hit_unit = _col_ray.unit
		if _hit_unit and _hit_unit:interaction() then
			local _interact_types = _hit_unit:interaction().tweak_data
			if (_interact_types == "pick_lock_easy_no_skill" or _interact_types == "open_from_inside") and
				not _hit_unit:interaction():active() then
				_hit_unit:damage():run_sequence_simple("anim_close_door")
				_hit_unit:interaction():set_active(true, true)
				managers.network:session():send_to_peers_synched("sync_interacted", _hit_unit, -2, self.tweak_data, 1)
			end
		end
	end
	_f_PlayerStandard_do_action_melee(self, t, ...)
end