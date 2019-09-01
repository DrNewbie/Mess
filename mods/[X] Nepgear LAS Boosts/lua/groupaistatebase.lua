Hooks:PreHook(GroupAIStateBase, "report_criminal_downed", "F_"..Idstring("PreHook:GroupAIStateBase:damage_explosion:NepgearLASBoosts"):key(), function(self, r_unit)
	if (r_unit:interaction() and r_unit:interaction():active()) or (r_unit:character_damage() and (r_unit:character_damage():need_revive() or r_unit:character_damage():arrested())) then
		if managers.player and managers.player:Is_LAS_Nepgear() and managers.player:local_player() then
			local ply_m = managers.player
			local ply_u = ply_m:local_player()
			if r_unit ~= ply_u then
				ply_u:character_damage():band_aid_health()
				ply_u:character_damage():_regenerate_armor()
				if ply_m:has_active_timer("replenish_grenades") then
					ply_m:start_timer("replenish_grenades", 0.1, callback(ply_m, ply_m, "_on_grenade_cooldown_end"))
					managers.hud:set_player_grenade_cooldown({
						end_time = managers.game_play_central:get_heist_timer() + 0.1,
						duration = 0.1
					})
				end
			end
		end
	end
end)