local ThisModMain = _G.MetalSlugGameModeMIds
_G[ThisModMain] = _G[ThisModMain] or {}

local M_Func = _G[ThisModMain]
local hook1 = M_Func.NameIds("PlayerStandard::_update_equip_weapon_timers")
local hook2 = M_Func.NameIds("PlayerStandard::update")
local func1 = M_Func.NameIds("PlayerStandard::func1")
local func2 = M_Func.NameIds("PlayerStandard::func2")
local func3 = M_Func.NameIds("PlayerStandard::func3")
local func4 = M_Func.NameIds("PlayerStandard::func4")
local func5 = M_Func.NameIds("PlayerStandard::func5")

local function __able_to_run(them)
	local __action_forbidden = them._shooting or 
		them:_is_reloading() or 
		them:in_steelsight() or 
		them:_changing_weapon() or 
		them:_is_meleeing() or 
		them._use_item_expire_t or 
		them:_interacting() or 
		them:_is_throwing_projectile() or 
		them:_is_deploying_bipod() or 
		them._menu_closed_fire_cooldown > 0 or 
		them:is_switching_stances() or 
		them:_is_cash_inspecting() or 
		them._running
	return not __action_forbidden
end

local function __reload_ammo_amount(them)
	if them._ext_inventory then
		for id, weapon in pairs(them._ext_inventory:available_selections() or {}) do
			if alive(weapon.unit) then
				managers.hud:set_ammo_amount(id, weapon.unit:base():ammo_info())
			end
		end
	end
	return
end

Hooks:PreHook(PlayerStandard, "_update_equip_weapon_timers", hook1, function(self, t, input)
	if M_Func.Is_Running then
		if __able_to_run(self) and self._change_weapon_data and type(self._change_weapon_data[func2]) == "table" and type(self._change_weapon_data[func2].__type) == "string" and self._change_weapon_data[func2].__type == ThisModMain then
			local wep_data = self._change_weapon_data[func2]
			self._change_weapon_data[func2] = nil
			if wep_data.factory_id and tweak_data.weapon.factory[wep_data.factory_id] then
				self._ext_inventory:add_unit_by_factory_name(wep_data.factory_id, true, false, wep_data.blueprint or tweak_data.weapon.factory[wep_data.factory_id].default_blueprint, wep_data.cosmetics, wep_data.texture_switches)
				if self._equipped_unit and alive(self._equipped_unit) then
					self:set_animation_weapon_hold(nil)
					local tweak_data = self._equipped_unit:base():weapon_tweak_data()
					self._equip_weapon_expire_t = t + (tweak_data.timers.equip or 0.7)
					self._ext_camera:play_redirect(self:get_animation("equip"), 1)
					managers.upgrades:setup_current_weapon()
					--[[
						Re-Apply again
					]]
					if not self[func5] then
						self[func5] = true
						self[func1](self, wep_data)
					else
						self._equipped_unit:base().allow_in_metal_slug_mod = true
						self._equipped_unit:base().metal_slug_gun_giving = wep_data
					end
				end
			end
			self._unequip_weapon_expire_t = nil
			self._equip_weapon_expire_t = nil
		end
	end
end)

Hooks:PostHook(PlayerStandard, "update", hook2, function(self, __t)
	if M_Func.Is_Running then
		if self._equipped_unit and self._equipped_unit:base() then
			if self._equipped_unit:base():weapon_tweak_data() and self._equipped_unit:base():get_ammo_ratio() > 0 then
				if not self._equipped_unit:base().allow_in_metal_slug_mod then
					self._equipped_unit:base():set_ammo_remaining_in_clip(0)
					self._equipped_unit:base():set_ammo_total(0)
					__reload_ammo_amount(self)
				end
			end
			if self._equipped_unit:base().metal_slug_gun_giving and not self:_changing_weapon() then
				call_on_next_update(function ()
					local wep_data = self._equipped_unit:base().metal_slug_gun_giving
					self._equipped_unit:base().metal_slug_gun_giving = nil
					if type(wep_data.ammo_max) == "number" then
						self._equipped_unit:base():set_ammo_max(wep_data.ammo_max)
					end
					if type(wep_data.ammo_total) == "number" then
						self._equipped_unit:base():set_ammo_total(wep_data.ammo_total)
					end
					if type(wep_data.ammo_max_per_clip) == "number" then
						self._equipped_unit:base():set_ammo_max_per_clip(wep_data.ammo_max_per_clip)
					end
					if type(wep_data.ammo_remaining_in_clip) == "number" then
						self._equipped_unit:base():set_ammo_remaining_in_clip(wep_data.ammo_remaining_in_clip)
					end
					self._equipped_unit:base()._ammo_pickup = {0, 0}
					__reload_ammo_amount(self)
				end)
			end
		end
		if self[func3] and self[func4] and __t > self[func3] then
			local __data = self[func4]
			self[func4] = nil
			self._change_weapon_pressed_expire_t = __t + 1.66
			self:_start_action_unequip_weapon(__t, __data)
		end
	end
end)

PlayerStandard[func1] = PlayerStandard[func1] or function(self, data)
	if M_Func.Is_Running then
		local __t = TimerManager:game():time()
		if type(data) == "table" and type(data.blueprint) == "table" then
			local _f_p = tweak_data.weapon.factory[data.factory_id]
			if not managers.dyn_resource:is_resource_ready(Idstring("unit"), Idstring(_f_p.unit), managers.dyn_resource.DYN_RESOURCES_PACKAGE) then
				managers.dyn_resource:load(Idstring("unit"), Idstring(_f_p.unit), managers.dyn_resource.DYN_RESOURCES_PACKAGE, callback(self, self, func1, data))
			else
				local __data = {
					selection_wanted = data.selection_wanted
				}
				__data[func2] = data
				self[func4] = __data
				self[func3] = __t + 1.66
			end
		end
	end
end