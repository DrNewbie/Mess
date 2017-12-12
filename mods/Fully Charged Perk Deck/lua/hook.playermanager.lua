Hooks:PostHook(PlayerManager, "init", "SetFullyChargedHitInit", function(self)
	self._fullycharged_hit = nil
end)

function PlayerManager:set_fullycharged_hit(hit_unitd)
	self._fullycharged_hit = hit_unitd
end

Hooks:PostHook(PlayerManager, "on_killshot", "CheckFullyChargedKill", function(self, killed_unit)
	if killed_unit == self._fullycharged_hit then
		self._fullycharged_hit = nil		
		local player = managers.player:player_unit()
		if player and player:has_category_upgrade("player", "passive_fully_charged_invulnerable") then
			local damage_ex = player:character_damage()
			if damage_ex and not damage_ex:arrested() and not damage_ex:need_revive() then
				damage_ex:set_fully_charged_invulnerable(true)
				damage_ex:restore_health(1, true)
			end
		end
	end
end)