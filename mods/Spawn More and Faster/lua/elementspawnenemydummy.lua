core:import("CoreMissionScriptElement")
ElementSpawnEnemyDummy = ElementSpawnEnemyDummy or class(CoreMissionScriptElement.MissionScriptElement)

function ElementSpawnEnemyDummy:on_executed(instigator)
	if not self._values.enabled then
		return
	end
	if not managers.groupai:state():is_AI_enabled() and not Application:editor() then
		return
	end
	if managers.groupai and managers.groupai:state() and managers.groupai:state():_SMF_GUI_Get_Enemy_Amount() > 45 then
		return
	end
	local unit = self:produce()
	ElementSpawnEnemyDummy.super.on_executed(self, unit)
end

local SFM_ElementSpawnEnemyDummy_ori_produce = ElementSpawnEnemyDummy.produce

function ElementSpawnEnemyDummy:produce(params)
	if not managers.groupai:state():is_AI_enabled() then
		return
	end
	local unit = SFM_ElementSpawnEnemyDummy_ori_produce(self, params)
	if unit:character_damage()._invulnerable or unit:character_damage()._immortal or unit:character_damage()._dead then
		return unit
	end
	if not managers.groupai or not managers.groupai:state() then
		return unit
	end
	if managers.groupai:state():is_enemy_converted_to_criminal(unit) then
		return unit
	end
	local _spawn_enemy = function (unit_name, pos, rot)
		local unit_done = safe_spawn_unit(unit_name, pos, rot)
		local team_id = tweak_data.levels:get_default_team_ID(unit_done:base():char_tweak().access == "gangster" and "gangster" or "combatant")
		unit_done:movement():set_team(managers.groupai:state():team_data( team_id ))
		managers.groupai:state():assign_enemy_to_group_ai(unit_done, team_id)
		return unit_done
	end
	if not managers.groupai:state():whisper_mode() then
		for i = 1, 3 do
			if not managers.groupai:state():is_enemy_special(unit) and managers.groupai:state():_SMF_GUI_Get_Enemy_Amount() > 70 then
				break
			end
			local enemy_name = Idstring("units/payday2/characters/ene_spook_1/ene_spook_1")
			if self:value("enemy") then
				enemy_name = self:value("enemy")
			elseif self._enemy_name then
				enemy_name = self._enemy_name
			elseif params and params.name then
				enemy_name = params.name
			end
			local pos, rot = self:get_orientation()
			local ang = math.random() * 360 * math.pi
			local rad = math.random(30, 50)
			local offset = Vector3(math.cos(ang) * rad, math.sin(ang) * rad, 0)
			local unit_done = _spawn_enemy(enemy_name, pos + offset, rot)
			table.insert(self._units, unit_done)
		end
	end
	return unit
end