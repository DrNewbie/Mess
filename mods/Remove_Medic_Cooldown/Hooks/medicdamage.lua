tweak_data.medic.cooldown = -1

Hooks:PreHook(MedicDamage, "heal_unit", "F_"..Idstring("PreHook:MedicDamage:heal_unit:Remove Medic Cooldown"):key(), function(self)
	if self._unit:anim_data() and self._unit:anim_data().act then
		self._unit:brain():action_request({
			body_part = 4,
			type = "stand"
		})
		self._unit:brain():set_objective(nil)
		self._unit:brain():set_logic("idle")
	end
end)