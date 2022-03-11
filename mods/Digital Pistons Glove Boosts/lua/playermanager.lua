local ThisModPath = ModPath or tostring(math.random())
local ThisModIds = Idstring(ThisModPath):key()
local __Name = function(__id)
	return "DPGB_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end
local Hook1 = __Name("init_finalize")
local Hook2 = __Name("get_melee_dmg_multiplier")
local Hook3 = __Name("_check_melee_dot_damage")
local Func1 = __Name("is_overkillpunk")

local AllowMelee = {
	["fists"] = true,
	["fight"] = true
}

if PlayerManager and RequiredScript == "lib/managers/playermanager" then
	PlayerManager[Func1] = function()
		if tostring(managers.blackmarket:equipped_glove_id()) == "overkillpunk" and AllowMelee[tostring(managers.blackmarket:equipped_melee_weapon())] then
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
					if character_unit:character_damage().damage_tase then
						local action_data = {
							variant = "light",
							damage = 0,
							attacker_unit = self._unit,
							col_ray = col_ray
						}
						character_unit:character_damage():damage_tase(action_data)
					end
				end
			end
		end
	end)
end