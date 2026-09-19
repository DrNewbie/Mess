Hooks:PostHook(PlayerManager, "update", "F_"..Idstring("PlayerManager:update:auto uses the stoic hip flask after it recharges"):key(), function(self)
	if self:player_unit() and self:player_unit():character_damage() and managers.blackmarket and self:can_throw_grenade() and managers.blackmarket:equipped_grenade() == "damage_control" then
		self:attempt_ability("damage_control")
	end
end)