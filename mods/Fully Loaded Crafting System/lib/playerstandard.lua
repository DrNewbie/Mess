local mod_ids = Idstring("Fully Loaded Crafting System"):key()
local __using_dt = "__d_"..Idstring("__using_dt:"..mod_ids):key()
local __using_ft = "__d_"..Idstring("__using_ft:"..mod_ids):key()
local __take_ammo_dt = "__d_"..Idstring("__take_ammo_dt:"..mod_ids):key()

local take_ammo = function(t, dt)
	local _success = false
	if type(managers.player[__take_ammo_dt]) == "number" then
		managers.player[__take_ammo_dt] = managers.player[__take_ammo_dt] - dt
		if managers.player[__take_ammo_dt] < 0 then
			managers.player[__take_ammo_dt] = nil
		end
		return true
	else
		managers.player[__take_ammo_dt] = 0.55
	end
	local weapon_list = {}
	local ammo_reduction = 0.02
	local leftover = 0
	for id, weapon in pairs(managers.player:player_unit():inventory():available_selections()) do
		local ammo_ratio = weapon.unit:base():get_ammo_ratio()
		if ammo_reduction > ammo_ratio then
			leftover = leftover + ammo_reduction - ammo_ratio
			weapon_list[id] = {
				unit = weapon.unit,
				amount = ammo_ratio,
				total = ammo_ratio
			}
		else
			weapon_list[id] = {
				unit = weapon.unit,
				amount = ammo_reduction,
				total = ammo_ratio
			}
		end
	end
	for id, data in pairs(weapon_list) do
		local ammo_left = data.total - data.amount
		if leftover > 0 and ammo_left > 0 then
			local extra_ammo = leftover > ammo_left and ammo_left or leftover
			leftover = leftover - extra_ammo
			data.amount = data.amount + extra_ammo
		end
		if 0 < data.amount then
			data.unit:base():reduce_ammo_by_procentage_of_total(data.amount)
			managers.hud:set_ammo_amount(id, data.unit:base():ammo_info())
			_success = true
		end
	end
	return _success
end

local old_update_check_actions = PlayerStandard._update_check_actions

function PlayerStandard:_update_check_actions(...)
	if managers.player[__using_dt] then
		self:_update_ground_ray()
		self:_update_fwd_ray()
		self:_update_movement(...)
		return
	end
	return old_update_check_actions(self, ...)
end

local old_get_max_walk_speed = PlayerStandard._get_max_walk_speed

function PlayerStandard:_get_max_walk_speed(...)
	local __ans = old_get_max_walk_speed(self, ...)
	return managers.player[__using_dt] and __ans*0.05 or __ans
end

Hooks:PostHook(PlayerStandard , "_update_check_actions", "F_"..Idstring("PostHook:PlayerStandard:_update_check_actions:"..mod_ids):key(), function(self, t, dt)
	if type(managers.player[__using_dt]) == "number" then
		local grenade_tweak = tweak_data.blackmarket.projectiles[managers.blackmarket:equipped_grenade()]
		local may_find_grenade = not grenade_tweak.base_cooldown and managers.player:has_category_upgrade("player", "regain_throwable_from_ammo")
		local current_state_name = self._unit:movement():current_state_name()
		if not may_find_grenade or 
			not take_ammo(t, dt) or 
			current_state_name == "empty" or 
			current_state_name == "mask_off" or 
			current_state_name == "bleed_out" or 
			current_state_name == "fatal" or 
			current_state_name == "arrested" or 
			current_state_name == "incapacitated" or 
			self:_changing_weapon() or 
			self:_is_reloading() or 
			self:_interacting() or 
			self:_is_meleeing() or 
			self._use_item_expire_t or 
			self:_is_throwing_projectile() or 
			self:_on_zipline() or 
			self._is_jumping then
				managers.player[__using_dt] = nil
				managers.hud:set_FLCS_SS_visible(false)
		else
			managers.player[__using_dt] = managers.player[__using_dt] - dt
			local totl = managers.player[__using_ft]
			local curr = totl - managers.player[__using_dt]
			managers.hud:set_FLCS_SS_visible(true)
			managers.hud:set_FLCS_SS(curr, totl, "Crafting...")
			if managers.player[__using_dt] <= 0 then
				managers.player[__using_dt] = nil
				managers.hud:set_FLCS_SS_visible(false)
				managers.player:add_grenade_amount(1, true)
				managers.hud:set_player_grenade_cooldown({
					end_time = managers.game_play_central:get_heist_timer() + 1,
					duration = 0.25
				})
			end
		end
	end
end)