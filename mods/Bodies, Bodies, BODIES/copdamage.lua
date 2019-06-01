_more_body_remote_unit_list = _more_body_remote_unit_list or {}

Hooks:PreHook(CopDamage, "_spawn_head_gadget", "CopDamage_more_spawn_head_gadget", function(self, params)
	if true then
		local _remote_unit = ' '
		local unit_name = self._unit:name()
		local unit_ids = Idstring('unit')
		if DB:has(unit_ids, unit_name) then
			if not _more_body_remote_unit_list[unit_name:key()] then
				xml_node = DB:load_node(unit_ids, unit_name)
				if xml_node and xml_node:children() then
					local xml_node_children = xml_node:children()
					for node in xml_node_children do
						if node:name() == 'network' then
							_remote_unit = tostring(node:parameter("remote_unit"))
							_more_body_remote_unit_list[unit_name:key()] = _remote_unit
							break
						end
					end
				end
			else
				_remote_unit = _more_body_remote_unit_list[unit_name:key()]
			end
		end
		_remote_unit = _remote_unit:gsub('_husk', '')
		if DB:has(unit_ids, Idstring(_remote_unit)) then
			for i = 1, 10 do
				local unit = safe_spawn_unit(Idstring(_remote_unit), params.position + Vector3(0, 0, 200), Vector3())
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
		end
	end
end)
