local ThisModPath = ModPath or tostring(math.random())

Hooks:PostHook(PlayerManager, "_on_grenade_cooldown_end", "MOD2_"..Idstring(ThisModPath):key(), function(self)
	if self:player_unit() then
		local __var1, __var2 = managers.blackmarket:equipped_grenade()
		local tweak = tweak_data.blackmarket.projectiles[__var1]
		if tweak and tweak.sounds and tweak.sounds.cooldown then
			self:player_unit():sound():play(tweak.sounds.cooldown)
		end
	end
end)

Hooks:PostHook(PlayerManager, "on_throw_grenade", "MOD3_"..Idstring(ThisModPath):key(), function(self)
	if self:player_unit() then
		local __var1, __var2 = managers.blackmarket:equipped_grenade()
		local tweak = tweak_data.blackmarket.projectiles[__var1]
		if tweak and tweak.sounds and tweak.sounds.activate then
			self:player_unit():sound():play(tweak.sounds.activate)
		end
	end
end)