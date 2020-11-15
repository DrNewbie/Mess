local mod_ids = Idstring('Emergency Defibrillation (Addon Equipment)'):key()
local _dt_ids = '_dt_'..Idstring('dt:'..mod_ids):key()
local _cd_ids = '_cd_'..Idstring('cd:'..mod_ids):key()
local _now_ids = '_now_'..Idstring('now:'..mod_ids):key()
local _rHP_ids = '_rHP_'..Idstring('rHP:'..mod_ids):key()
local _gHP_ids = '_gHP_'..Idstring('gHP:'..mod_ids):key()
local _dtHP_ids = '_dtHP_'..Idstring('dtHP:'..mod_ids):key()
local _cdHP_ids = '_cdHP_'..Idstring('cdHP:'..mod_ids):key()

local function __pre_check(them)
	if them and them._unit and managers.player:player_unit() and them._unit == managers.player:player_unit() and type(them[_now_ids]) == "number" then
		return true
	else
		return false
	end
end

local function __post_update(them, t)
	if __pre_check(them) then
		them[_now_ids] = t
	else
		them[_now_ids] = 1
		them[_dt_ids] = 0
		them[_cd_ids] = 600
		them[_rHP_ids] = 0.01
		them[_gHP_ids] = 0.15
		them[_dtHP_ids] = 0
		them[_cdHP_ids] = 7
	end
	return them
end

local function __pre_calc_health_damage(them, dmg)
	if __pre_check(them) then
		if type(dmg) == "number" and dmg < 0 then
			dmg = -dmg
			local __hp_after_dmg = them:get_real_health() - dmg
			local __ratio = math.min(__hp_after_dmg / them:_max_health(), 1)
			if them[_dt_ids] <= them[_now_ids] then
				if __ratio <= them[_rHP_ids] then
					managers.player:local_player():sound_source():post_event("doom2016_low_on_health")
					them[_dt_ids] = them[_now_ids] + them[_cd_ids]
					them[_dtHP_ids] = them[_now_ids] + them[_cdHP_ids]
					them:set_health(them:_max_health() * them[_gHP_ids])
					return them, true
				end
			end
			if them[_dtHP_ids] >= them[_now_ids] then
				return them, true
			end
		end
	end
	return them, false
end

if PlayerDamage then
	Hooks:PostHook(PlayerDamage, "update", 'F_'..Idstring("PostHook:PlayerDamage:update:"..mod_ids):key(), function(self, unit, t, dt)
		self = __post_update(self, t)
	end)
	local old_calc_health_damage = PlayerDamage._calc_health_damage
	function PlayerDamage:_calc_health_damage(attack_data, ...)
		local __ans
		self, __ans = __pre_calc_health_damage(self, -attack_data.damage)
		if __ans then
			return 0
		end
		return old_calc_health_damage(self, attack_data, ...)
	end
end