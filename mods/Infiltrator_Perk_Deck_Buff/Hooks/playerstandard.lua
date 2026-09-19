Hooks:PostHook(PlayerStandard, "_check_action_primary_attack", "F_"..Idstring("PostHook:PlayerStandard:_check_action_primary_attack:Infiltrator Perk Deck Buff"):key(), function(self)
	if self:shooting() then
		managers.player:__add_infiltrator_damage_dampener_bonus_cd()
	end
end)