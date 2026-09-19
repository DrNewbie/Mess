local ThisModPath = ModPath or tostring(math.random())
local ThisModIds = Idstring(ThisModPath):key()
local __Name = function(__id)
	return "DSGB_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end
local Hook1 = __Name("init_finalize")
local Hook2 = __Name("get_melee_dmg_multiplier")
local Hook3 = __Name("_check_melee_dot_damage")
local Func1 = __Name("is_dragonscale")

local AllowMelee = {
	["fists"] = true,
	["fight"] = true
}

if PlayerManager and RequiredScript == "lib/managers/playermanager" then
	PlayerManager[Func1] = function()
		if tostring(managers.blackmarket:equipped_glove_id()) == "dragonscale" and AllowMelee[tostring(managers.blackmarket:equipped_melee_weapon())] then
			return true
		end
		return false
	end

	PlayerManager[Hook2] = PlayerManager[Hook2] or PlayerManager.get_melee_dmg_multiplier
	function PlayerManager:get_melee_dmg_multiplier(...)
		local Ans = self[Hook2](self, ...)
		if self[Func1]() then
			Ans = Ans * 1000 / 100
		end
		return Ans
	end
end

if PlayerStandard and RequiredScript == "lib/units/beings/player/states/playerstandard" then
	Hooks:PostHook(PlayerStandard, "_check_melee_dot_damage", Hook3, function(self, col_ray, defense_data, melee_entry)
		if col_ray and alive(col_ray.unit) and managers.player[Func1]() then
			if not defense_data or defense_data.type == "death" then
			
			else
				local hit_unit = col_ray.unit
				if hit_unit:character_damage() then
					local character_unit = hit_unit
					if hit_unit:in_slot(8) and alive(hit_unit:parent()) then
						character_unit = hit_unit:parent()
					end
					if character_unit:character_damage().damage_fire then
						local action_data = {
							variant = "fire",
							damage = 0,
							attacker_unit = self._unit,
							col_ray = col_ray,
							fire_dot_data = {
								dot_trigger_chance = 1000,
								dot_damage = 30,
								dot_length = 3,
								dot_trigger_max_distance = 3000,
								dot_tick_period = 0.15
							}
						}
						character_unit:character_damage():damage_fire(action_data)
					end
				end
			end
		end
	end)
end