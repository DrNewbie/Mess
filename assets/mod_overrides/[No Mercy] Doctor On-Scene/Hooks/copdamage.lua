if not Global.game_settings or not Global.game_settings.level_id or not Global.game_settings.level_id == "nmh" then
	return
end

function CopDamage:heal_unit(unit, override_cooldown)
	if not Global.game_settings or not Global.game_settings.level_id or not Global.game_settings.level_id == "nmh" then
		return
	end
	if not self._unit:base()._medic_now then
		return false
	end
	local t = Application:time()
	local cooldown = tweak_data.medic.cooldown
	cooldown = managers.modifiers:modify_value("MedicDamage:CooldownTime", cooldown)
	self._heal_cooldown_t = self._heal_cooldown_t or 0
	if t < self._heal_cooldown_t + cooldown and not override_cooldown then
		return false
	end
	if self._unit:anim_data() and self._unit:anim_data().act then
		return false
	end
	local tweak_table = unit:base()._tweak_table
	if table.contains(tweak_data.medic.disabled_units, tweak_table) then
		return false
	end
	if unit:brain() and unit:brain()._logic_data then
		local team = unit:brain()._logic_data.team
		if team and team.id ~= "law1" and (not team.friends or not team.friends.law1) then
			return false
		end
	end
	if unit:brain() and unit:brain()._logic_data and unit:brain()._logic_data.is_converted then
		return false
	end
	local cop_dmg = unit:character_damage()
	cop_dmg._health = cop_dmg._HEALTH_INIT
	cop_dmg._health_ratio = 1
	cop_dmg:_update_debug_ws()
	self._heal_cooldown_t = t
	if not self._unit:character_damage():dead() then
		local action_data = {
			body_part = 3,
			type = "heal",
			client_interrupt = Network:is_client() and true or false
		}
		self._unit:movement():action_request(action_data)
	end
	managers.modifiers:run_func("OnEnemyHealed", self._unit, unit)
	managers.network:session():send_to_peers("sync_medic_heal", self._unit)
	return true
end