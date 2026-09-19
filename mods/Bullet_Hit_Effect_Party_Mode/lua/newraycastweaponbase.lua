_G.PartyModeCheatCode = _G.PartyModeCheatCode or {}

if PackageManager:package_exists("package/balloon_pop_effect") then
	PackageManager:load("package/balloon_pop_effect")
	PartyModeCheatCode.__package_loaded = true
end

local HookPartyModeCheatCode = NewRaycastWeaponBase.fire

Hooks:PostHook(NewRaycastWeaponBase, "fire", "F_"..Idstring("PostHook:NewRaycastWeaponBase:fire:Bullet Hit Effect: Party Mode"):key(), function(self, from_pos, direction)
	PartyModeCheatCode:SpawnEffect(self, tostring(self._name_id), from_pos, direction)
end)

PartyModeCheatCode.__possible_effect = {
	"effects/payday2/particles/explosions/balloon_pop_purple",
	"effects/payday2/particles/explosions/balloon_pop_blue",
	"effects/payday2/particles/explosions/balloon_pop_orange",
	"effects/payday2/particles/explosions/balloon_pop_green",
	"effects/payday2/particles/explosions/balloon_pop_red",
	"effects/payday2/particles/explosions/balloon_pop_white"
}

PartyModeCheatCode.__effect_spawn_dt = 0
PartyModeCheatCode.__effect_spawn_cd = 0.6

--[[
PartyModeCheatCode.__possible_ogg = {
}

PartyModeCheatCode.__ogg_spawn_dt = 0
PartyModeCheatCode.__ogg_spawn_cd = 4
]]

PartyModeCheatCode.__pos_offset = function ()
	local ang = math.random() * 360 * math.pi
	local rad = math.random(2, 30)
	return Vector3(math.cos(ang) * rad, math.sin(ang) * rad, 0)
end

PartyModeCheatCode.__now_time = function ()
	return TimerManager:game():time()	
end

function PartyModeCheatCode:SpawnEffect(them, name_id, from_pos, direction)
	if self.__package_loaded then
		local mvec_to = Vector3()		
		mvector3.set(mvec_to, direction)
		mvector3.multiply(mvec_to, 20000)
		mvector3.add(mvec_to, from_pos)
		local col_ray = World:raycast("ray", from_pos, mvec_to, "slot_mask", managers.slot:get_mask("bullet_impact_targets"), "ignore_unit", them._setup.ignore_units)
		local __spawn_pos
		if col_ray and col_ray.hit_position then
			__spawn_pos = col_ray.hit_position
			--[[
			if self:__now_time() > self.__ogg_spawn_dt then
				self.__ogg_spawn_dt = self:__now_time() + self.__ogg_spawn_cd
				managers.player:player_unit():sound():_play(table.random(self.__possible_ogg))
			end
			]]
		else
			__spawn_pos = from_pos
		end
		if self:__now_time() > self.__effect_spawn_dt then
			self.__effect_spawn_dt = self:__now_time() + self.__effect_spawn_cd
			for i = 1, (1+math.random()*4) do
				World:effect_manager():spawn({
					effect = Idstring(table.random(self.__possible_effect)),
					position = __spawn_pos + self:__pos_offset()
				})
			end
		end
	end
end