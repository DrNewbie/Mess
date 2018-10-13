_G.GunGameGame = _G.GunGameGame or {}

local GunGameEquipNewWeapon = PlayerStandard._start_action_equip_weapon

function PlayerStandard:_start_action_equip_weapon(t, ...)
	if self._change_weapon_data.selection_gungame then
		local wep_data = self._change_weapon_data.wep_data
		self._ext_inventory:add_unit_by_factory_name(wep_data.factory_id, true, false, wep_data.blueprint, wep_data.cosmetics, wep_data.texture_switches)
		
		self:set_animation_weapon_hold(nil)
		local speed_multiplier = self:_get_swap_speed_multiplier()
		self._equipped_unit:base():tweak_data_anim_stop("unequip")
		self._equipped_unit:base():tweak_data_anim_play("equip", speed_multiplier)
		local tweak_data = self._equipped_unit:base():weapon_tweak_data()
		self._equip_weapon_expire_t = t + (tweak_data.timers.equip or 0.7) / speed_multiplier
		self._ext_camera:play_redirect(self:get_animation("equip"), speed_multiplier)
		self._equipped_unit:base():tweak_data_anim_stop("unequip")
		self._equipped_unit:base():tweak_data_anim_play("equip", speed_multiplier)
		managers.upgrades:setup_current_weapon()
		return
	end
	GunGameEquipNewWeapon(self, t, ...)
end

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
			if managers.blackmarket:weapon_unlocked(wep_id) then
				table.insert(_weapon_list_safe, wep_id)
			end
		end
		local _weapon_id = table.random(_weapon_list_safe)
		if _weapon_id then
			local _factory_id = managers.weapon_factory:get_factory_id_by_weapon_id(_weapon_id)
			wep_data = {
				factory_id = _factory_id,
				blueprint = tweak_data.weapon.factory[_factory_id].default_blueprint,
				selection_wanted = tweak_data.weapon[_weapon_id].use_data.selection_index
			}
		end
	end
	self._change_weapon_pressed_expire_t = t + 0.33
	self:_start_action_unequip_weapon(t, {selection_gungame = wep_data.selection_wanted, wep_data = wep_data})
	managers.player:send_message(Message.OnSwitchWeapon)
end

function PlayerStandard:AskGunGunRun()
	if not self._gumgame_times then
		return
	end
	self._gumgame_times = self._gumgame_times + 1
	self._gumgame_req_chanage_weapon = 1
end

Hooks:PostHook(PlayerStandard, "update", "PlySGunGunUpdate", function(self, t ,dt)
	if self._gumgame_times and self._gumgame_req_chanage_weapon then
		local action_forbidden = self:_changing_weapon()
		action_forbidden = action_forbidden or self:_is_meleeing() or self._use_item_expire_t or self._change_item_expire_t
		action_forbidden = action_forbidden or self._unit:inventory():num_selections() == 1 or self:_interacting() or self:_is_throwing_projectile() or self:_is_deploying_bipod()
		if not action_forbidden then
			self._gumgame_req_chanage_weapon = self._gumgame_req_chanage_weapon - dt
			if self._gumgame_req_chanage_weapon <= 0 then
				self._gumgame_req_chanage_weapon = nil
				self:DoGunGuChanageWeapon(t)
			end
		end
	end
end)

Hooks:PostHook(PlayerStandard, "init", "PlySGunGunInit", function(self)
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