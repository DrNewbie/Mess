local ThisModPath = ModPath

local mod_ids = Idstring(ThisModPath):key()
local hook1 = "EEA_"..Idstring("sp_impulse_fields::hook1::"..mod_ids):key()

local function __pre_check(them)
	if them and them._unit and managers.player:player_unit() and them._unit == managers.player:player_unit() then
		local sp_impulse_fields = managers.player:__EE_Armor_Get_Var_by_Lv_and_ID(nil, 10)
		if type(sp_impulse_fields) == "number" and sp_impulse_fields > 0 then
			return true
		end
	end
	return false
end

local function __pre_calc_health_damage(them, dmg)
	if __pre_check(them) then
		if type(dmg) == "number" and dmg < 0 then
			dmg = -dmg
			local __hp50 = them:_max_health()*0.5
			if them:get_real_health() >= __hp50 and dmg > __hp50 then
				dmg = __hp50 + 0.1
				return true, dmg
			end
		end
	end
	return false, dmg
end

PlayerDamage[hook1] = PlayerDamage[hook1] or PlayerDamage._calc_health_damage
function PlayerDamage:_calc_health_damage(attack_data, ...)
	local __ans, __dmg = __pre_calc_health_damage(self, -attack_data.damage)
	if __ans then
		attack_data.damage = __dmg
	end
	return self[hook1](self, attack_data, ...)
end