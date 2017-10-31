_G.Rage_Special = _G.Rage_Special or {}

function PlayerDamage:forced_swansong()
	self._listener_holder:add("on_enter_swansong", {
		"on_enter_swansong"
	}, callback(self, self, "_on_enter_swansong_event"))
	self._listener_holder:add("on_exit_swansong", {
		"on_enter_bleedout"
	}, callback(self, self, "_on_exit_swansong_event"))
	
	managers.hud:set_teammate_condition(HUDManager.PLAYER_PANEL, "mugshot_swansong", managers.localization:text("debug_mugshot_downed"))
	managers.player:activate_temporary_upgrade("temporary", "berserker_damage_multiplier")
	self._current_state = nil
	self._check_berserker_done = true
	if alive(self._interaction:active_unit()) and not self._interaction:active_unit():interaction():can_interact(self._unit) then
		self._unit:movement():interupt_interact()
	end
	self._listener_holder:call("on_enter_swansong")
end

local _Rage_PlayerDamage_on_enter_swansong_event = PlayerDamage._on_enter_swansong_event

function PlayerDamage:_on_enter_swansong_event()
	_Rage_PlayerDamage_on_enter_swansong_event(self)
	if Rage_Special.Activating and not Rage_Special.Activating_Ready_to_End_RUN then
		self:_add_on_damage_event()
	end
end

local _Rage_PlayerDamage_force_into_bleedout = PlayerDamage.force_into_bleedout

function PlayerDamage:force_into_bleedout(...)
	if Rage_Special.Activating then
		Rage_Special.Activating = false
		Rage_Special.Activating_Ready_to_End_RUN = true
		Rage_Special.Rage_Point = 0
		if self:get_real_health() > 0 then
			return
		end
	end
	return _Rage_PlayerDamage_force_into_bleedout(self, ...)
end

local _Rage_PlayerDamage_calc_health_damage = PlayerDamage._calc_health_damage
function PlayerDamage:_calc_health_damage(attack_data)
	if attack_data.damage > 0 then
		Rage_Special.Rage_Point_Gain = math.clamp(attack_data.damage * 0.5, 1, 8)
	end
	return _Rage_PlayerDamage_calc_health_damage(self, attack_data)
end

local _Rage_PlayerDamage_damage_melee = PlayerDamage.damage_melee
function PlayerDamage:damage_melee(attack_data)
	if Rage_Special.Activating and attack_data and attack_data.damage then
		attack_data.damage = attack_data.damage * 0.5
	end
	_Rage_PlayerDamage_damage_melee(self, attack_data)
end

local _Rage_PlayerDamage_damage_explosion = PlayerDamage.damage_explosion
function PlayerDamage:damage_explosion(attack_data)
	if Rage_Special.Activating and attack_data and attack_data.damage then
		attack_data.damage = attack_data.damage * 0.5
	end
	_Rage_PlayerDamage_damage_explosion(self, attack_data)
end

local _Rage_PlayerDamage_damage_fire = PlayerDamage.damage_fire
function PlayerDamage:damage_fire(attack_data)
	if Rage_Special.Activating and attack_data and attack_data.damage then
		attack_data.damage = attack_data.damage * 0.5
	end
	_Rage_PlayerDamage_damage_fire(self, attack_data)
end

local _Rage_PlayerDamage_damage_bullet = PlayerDamage.damage_bullet
function PlayerDamage:damage_bullet(attack_data)
	if Rage_Special.Activating and attack_data and attack_data.damage then
		attack_data.damage = attack_data.damage * 0.5
	end
	_Rage_PlayerDamage_damage_bullet(self, attack_data)
end

local _Rage_PlayerDamage_damage_killzone = PlayerDamage.damage_killzone
function PlayerDamage:damage_killzone(attack_data)
	if Rage_Special.Activating and attack_data and attack_data.damage then
		attack_data.damage = attack_data.damage * 0.5
	end
	_Rage_PlayerDamage_damage_killzone(self, attack_data)
end