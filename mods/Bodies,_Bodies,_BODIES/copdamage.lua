Hooks:PreHook(CopDamage, "_spawn_head_gadget", "CopDamage_more_spawn_head_gadget", function(self, params)
	local unit_name = self._unit:name()
	for i = 1, 10 do
		local unit = safe_spawn_unit(unit_name, params.position + Vector3(0, 0, 200), Vector3())
		if unit then
			local dir = math.UP - params.dir / 2
			local _access = unit:base():char_tweak().access
			local team = _access == "gangster" and "gangster" or "combatant"
			local team_id = tweak_data.levels:get_default_team_ID(team)
			unit:movement():set_team(managers.groupai:state():team_data(team_id))
			unit:brain():set_spawn_ai({init_state = "idle"})
			unit:brain():set_active(false)
			unit:character_damage():set_pickup(nil)
			call_on_next_update(function ()
				unit:character_damage():damage_mission({damage = 9999999, forced = true})
				call_on_next_update(function ()
					managers.game_play_central:do_shotgun_push(unit, params.position + Vector3(math.rand(1), math.rand(1), math.rand(1)), dir * math.random(), math.random(1, 50), managers.player:player_unit())
				end)
			end)
		end
	end
end)
