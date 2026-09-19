Hooks:PostHook(PlayerManager, "on_damage_dealt", "HitSound.OnHit.OwO", function(self)
	local player_unit = self:player_unit()
	if not player_unit then
		return
	end
	player_unit:sound():_play("Hitsound")
end)