local __ids_mod = Idstring("Weapon Rotation Randomizer"):key()
local __ids_mod_dt = "__"..Idstring(__ids_mod.."_dt"):key()
local __rnd_n2p = function ()
	return math.random(360)*((math.random(1,2)*2)-3)
end

Hooks:PostHook(PlayerStandard, "update", "F_"..Idstring("PostHook:PlayerStandard:update:"..__ids_mod):key(), function(self, t, dt)
	if self._equipped_unit and alive(self._equipped_unit) then
		if not self[__ids_mod_dt] then
			self[__ids_mod_dt] = dt * 1.2
			self._equipped_unit:set_rotation( Vector3(__rnd_n2p(), __rnd_n2p(), __rnd_n2p()) )
		else
			self[__ids_mod_dt] = self[__ids_mod_dt] - dt
			if self[__ids_mod_dt] <= 0 then
				self[__ids_mod_dt] = nil
			end
		end
	end
end)

