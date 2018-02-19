Hooks:PostHook(PlayerDamage, "init", "pulverizer_ply_dmg_init", function(self)
	if managers.player:has_category_upgrade("player", "passive_pulverizer_health_regen") then
		self._pulverizer_health_regen_t = 1
	end
	if managers.player:has_category_upgrade("player", "passive_pulverizer_armor_regen") then
		self._pulverizer_armor_regen_t = 1
	end
	if managers.player:has_category_upgrade("player", "passive_pulverizer_damage_stack") then
		self._pulverizer_damage_stack_t = 1
		self._pulverizer_damage_stack_s = 0
	end
end)

Hooks:PostHook(PlayerDamage, "_upd_health_regen", "pulverizer_upd_health_regen", function(self, t)
	if self._unit:movement()._current_state:_is_meleeing() then
		if self._pulverizer_health_regen_t and t > self._pulverizer_health_regen_t and not self:full_health() then
			self._pulverizer_health_regen_t = t + 1
			self:restore_health(managers.player:upgrade_value("player", "passive_pulverizer_health_regen", 0), false)
			self:restore_health(managers.player:fixed_health_regen(self:health_ratio()), true)
		end
	end
	if t > self._pulverizer_armor_regen_t and t > self._pulverizer_armor_regen_t and self:get_real_armor() < self:_max_armor() then
		self._pulverizer_armor_regen_t = t + 1
		self:restore_armor(managers.player:upgrade_value("player", "passive_pulverizer_armor_regen", 0), true)
	end
end)