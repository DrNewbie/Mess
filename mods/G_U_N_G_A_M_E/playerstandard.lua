_G.GunGameGame = _G.GunGameGame or {}

local GunGameGame_ids = Idstring("GunGameGame")
local GunGameGame_key = Idstring("GunGameGame"):key()
local GunGameGame_now_t = '___'..GunGameGame_key..'_now_t'

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

Hooks:PreHook(PlayerStandard, "_update_equip_weapon_timers", "F_"..Idstring("PostHook:PlayerStandard:_update_equip_weapon_timers:G U N G A M E"):key(), function(self, t, input)
	if __able_to_run(self) and self._change_weapon_data and self._change_weapon_data.selection_gungame then
		self._change_weapon_data.selection_gungame = nil
		local wep_data = self._change_weapon_data.wep_data
		if wep_data.factory_id and tweak_data.weapon.factory[wep_data.factory_id] then
			self._ext_inventory:add_unit_by_factory_name(wep_data.factory_id, true, false, wep_data.blueprint or tweak_data.weapon.factory[wep_data.factory_id].default_blueprint, wep_data.cosmetics, wep_data.texture_switches)
			if self._equipped_unit and alive(self._equipped_unit) then
				self:set_animation_weapon_hold(nil)
				local speed_multiplier = 1
				local tweak_data = self._equipped_unit:base():weapon_tweak_data()
				self._equip_weapon_expire_t = t + (tweak_data.timers.equip or 0.7) / speed_multiplier
				self._ext_camera:play_redirect(self:get_animation("equip"), speed_multiplier)
				managers.upgrades:setup_current_weapon()
			end
		end
		self._unequip_weapon_expire_t = nil
		self._equip_weapon_expire_t = nil
		return
	end
end)

function PlayerStandard:DoGunGuChanageWeaponNow(data)
	local t = self[GunGameGame_now_t] and self[GunGameGame_now_t] or 0
	if type(data) == "table" and type(data.wep_data) == "table" and type(data.wep_data.blueprint) == "table" then
		local _f_p = tweak_data.weapon.factory[data.wep_data.factory_id]
		if not managers.dyn_resource:is_resource_ready(Idstring("unit"), Idstring(_f_p.unit), managers.dyn_resource.DYN_RESOURCES_PACKAGE) then
			managers.dyn_resource:load(Idstring("unit"), Idstring(_f_p.unit), managers.dyn_resource.DYN_RESOURCES_PACKAGE, callback(self, self, "DoGunGuChanageWeaponNow", data))
		else
			self._change_weapon_pressed_expire_t = t + 1.66
			self:_start_action_unequip_weapon(t, data)
			managers.player:send_message(Message.OnSwitchWeapon)
		end
	end
end

GunGameGame = GunGameGame or {}
GunGameGame.settings = GunGameGame.settings or {}
GunGameGame.settings.chance = GunGameGame.settings.chance or 30
GunGameGame.settings.rndMod = GunGameGame.settings.rndMod or 0

function PlayerStandard:DoGunGuChanageWeapon(t)
	if not self._gumgame_times or type(self._gumgame_weps) ~= "table" or not self._gumgame_weps[1] then
		return
	end
	local wep_key = table.random_key(self._gumgame_weps)
	local wep_data = self._gumgame_weps[wep_key]	
	local _, _, _, _weapon_list, _, _, _, _, _, _ = tweak_data.statistics:statistics_table()
	if math.random()*100 <= GunGameGame.settings.chance and type(_weapon_list) == "table" then
		local _weapon_list_safe = {}
		for id, wep_id in pairs(_weapon_list) do
			if Global.blackmarket_manager.weapons[wep_id] and managers.blackmarket:weapon_unlocked(wep_id) then
				table.insert(_weapon_list_safe, wep_id)
			end
		end
		local _weapon_id = table.random(_weapon_list_safe)
		if _weapon_id then
			local _factory_id = managers.weapon_factory:get_factory_id_by_weapon_id(_weapon_id)
			wep_data = {
				addon = true,
				weapon_id = _weapon_id,
				factory_id = _factory_id,
				blueprint = tweak_data.weapon.factory[_factory_id].default_blueprint,
				selection_wanted = tweak_data.weapon[_weapon_id].use_data.selection_index
			}
		end
	end
	if math.random()*100 <= GunGameGame.settings.rndMod and wep_data and wep_data.addon and type(wep_data.blueprint) == "table" then
		--[[
			https://github.com/segabl/pd2-player-randomizer/blob/master/randomizer.lua
		]]
		local _dropable_mods = managers.blackmarket:get_dropable_mods_by_weapon_id(wep_data.weapon_id)
		for part_type, parts in pairs(_dropable_mods) do
			local skip_chance = math.random()
			local skip_part_type = part_type == "custom" and skip_chance <= 0.7 or part_type == "ammo" and skip_chance <= 0.4 or skip_chance <= 0.2
			if not skip_part_type then
				local filtered_parts = table.filter_list(parts, function (part_id)
					local part = tweak_data.weapon.factory.parts[part_id[1]]
					return not managers.weapon_factory:_get_forbidden_parts(wep_data.factory_id, wep_data.blueprint)[part_id[1]] and (not part.dlc or managers.dlc:is_dlc_unlocked(part.dlc))
				end)
				local part_id = table.random(filtered_parts)
				if part_id then
					managers.weapon_factory:change_part_blueprint_only(wep_data.factory_id, part_id[1], wep_data.blueprint)
				end
			end
		end
	end
	self:DoGunGuChanageWeaponNow({selection_gungame = wep_data.selection_wanted, wep_data = wep_data})
end

function PlayerStandard:AskGunGunRun()
	if not self._gumgame_times then
		return
	end
	self._gumgame_times = self._gumgame_times + 1
	self._gumgame_req_chanage_weapon = 1
end

Hooks:PostHook(PlayerStandard, "update", "F_"..Idstring("PostHook:PlayerStandard:update:G U N G A M E"):key(), function(self, t ,dt)
	if self._gumgame_times and self._gumgame_req_chanage_weapon then
		local action_forbidden = self:_changing_weapon()
		action_forbidden = action_forbidden or self:_is_meleeing() or self._use_item_expire_t or self._change_item_expire_t
		action_forbidden = action_forbidden or self._unit:inventory():num_selections() == 1 or self:_interacting() or self:_is_throwing_projectile() or self:_is_deploying_bipod()
		if not action_forbidden and __able_to_run(self) then
			self._gumgame_req_chanage_weapon = self._gumgame_req_chanage_weapon - dt
			if self._gumgame_req_chanage_weapon <= 0 then
				self._gumgame_req_chanage_weapon = nil
				self:DoGunGuChanageWeapon(t)
			end
		end
	end
	self[GunGameGame_now_t] = t
end)

Hooks:PostHook(PlayerStandard, "init", "F_"..Idstring("PostHook:PlayerStandard:init:G U N G A M E"):key(), function(self)
	if managers.blackmarket and Global.blackmarket_manager and type(Global.blackmarket_manager.crafted_items) == "table" then
		self._gumgame_times = 1
		self._gumgame_weps = {}
		for _selection_wanted, cat in pairs({"secondaries", "primaries"}) do
			for _, wep in pairs(managers.blackmarket:get_crafted_category(cat)) do
				wep.selection_wanted = _selection_wanted
				table.insert(self._gumgame_weps, wep)
			end
		end
	end
end)