local __ids_carry_nuke = Idstring("Carry Nuke Hurt You:OwO"):key()
local __ids_carry_nuke_dt = Idstring(__ids_carry_nuke..":__ids_carry_nuke_dt:OwO"):key()

Hooks:PostHook(PlayerCarry, "update", "F_"..Idstring("PostHook:PlayerCarry:update:"..__ids_carry_nuke):key(), function(self, t, dt)
	if managers.player and managers.player:get_my_carry_data() and managers.player:player_unit() and managers.player:player_unit():character_damage() then
		local my_carry_data = managers.player:get_my_carry_data()
		if my_carry_data and my_carry_data.carry_id and my_carry_data.carry_id == "warhead" then
			if self[__ids_carry_nuke_dt] then
				self[__ids_carry_nuke_dt] = self[__ids_carry_nuke_dt] - dt
				if self[__ids_carry_nuke_dt] <= 0 then
					self[__ids_carry_nuke_dt] = nil
				end
			else
				self[__ids_carry_nuke_dt] = 1
				managers.player:player_unit():character_damage():damage_killzone({
					variant = "killzone",
					damage = 1,
					col_ray = {
						ray = math.UP
					}
				})				
			end
		end
	end
end)