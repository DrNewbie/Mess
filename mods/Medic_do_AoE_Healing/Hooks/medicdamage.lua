local mod_ids = Idstring("Medic do AoE Healing"):key()
local old_func1 = "__old_"..Idstring("old_func1:"..mod_ids):key()
MedicDamage[old_func1] = MedicDamage[old_func1] or MedicDamage.heal_unit
Hooks:PostHook(MedicDamage, "heal_unit", "F_"..Idstring("PostHook:MedicDamage:heal_unit:"..mod_ids):key(), function(self)
	local enemies = World:find_units_quick(self._unit, "sphere", self._unit:position(), tweak_data.medic.radius, managers.slot:get_mask("enemies"))
	local is_done = false
	for _, enemy in pairs(enemies) do
		local is_bool = false
		if enemy:brain() and enemy:brain()._logic_data then
			local team = enemy:brain()._logic_data.team
			if team and team.id ~= "law1" and (not team.friends or not team.friends.law1) then
				is_bool = true
			end
		end
		if enemy:brain() and enemy:brain()._logic_data and enemy:brain()._logic_data.is_converted then
			is_bool = true
		end
		if not is_bool then
			local cop_dmg = enemy:character_damage()
			cop_dmg._health = cop_dmg._HEALTH_INIT
			cop_dmg._health_ratio = 1
			cop_dmg:_send_bullet_attack_result({}, self._unit, -0.1, CopDamage.BODY_INDEX_MAX, 0, 3)
			if enemy:contour() then
				enemy:contour():add("medic_heal", true)
				enemy:contour():flash("medic_heal", 0.2)
			end
			managers.modifiers:run_func("OnEnemyHealed", self._unit, enemy)
			is_done = true
		end
	end
	if is_done and not self._unit:character_damage():dead() then
		local action_data = {
			body_part = 3,
			type = "heal",
			client_interrupt = Network and Network:is_client() and true or false
		}
		self._unit:movement():action_request(action_data)
	end
end)