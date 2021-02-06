_G.RRModTest002 = {}

RRModTest002._path = ModPath
RRModTest002._save_path = SavePath .. "RRModTest002Settings.txt"

RRModTest002.settings = {
	rrmodtest002_open_menu = "l",
	menu_click_on_release = true
}

RRModTest002.tweakdata = {
	ws_h = 1000,
	ws_w = 1000,
	unselected_alpha = 0.25,
	selected_alpha = 1,
	bitmap_rotation_speed = 45,
	color_aimed_at = Color("FFD700"),
	color_unselected = Color(1,1,1),
	color_mode_manual = Color(1,0,0),
	color_mode_overwatch = Color(1,1,0)
}

RRModTest002.__weapon_ammo = {
	standard = 1,
	poison = 1,
	explosion = 1,
	AP = 1
}

function RRModTest002:UsingRightWeapon()
	if not managers.player or not managers.player:local_player() or not managers.player:local_player():inventory() then
		return false
	end
	local ply = managers.player:local_player()
	local ply_inv = ply:inventory()
	if not ply_inv:equipped_unit() or not ply_inv:equipped_unit():base() then
		return false
	end
	local name_id = ply_inv:equipped_unit():base():get_name_id()
	if not name_id then
		return false
	end
	local factory_id = managers.weapon_factory:get_factory_id_by_weapon_id(name_id)
	if not factory_id then
		return false
	end
	local factory_data = tweak_data.weapon.factory[factory_id]
	if not factory_id or not factory_data.uses_parts then
		return false
	end
	return ply_inv:equipped_unit():base()
end

function RRModTest002:InitWeaponArrowData(weapon_base)
	weapon_base = weapon_base or self:UsingRightWeapon()
	if weapon_base then
		local name_id = weapon_base:get_name_id()
		if name_id then
			local factory_id = managers.weapon_factory:get_factory_id_by_weapon_id(name_id)
			if factory_id then
				local factory_data = tweak_data.weapon.factory[factory_id]
				if factory_data then
					self.__ammo_poison = nil
					self.__ammo_explosive = nil
					self.__ammo_AP = nil
					self.__ammo_standard = "Z_"..Idstring("RRModTest002"):key()
					for _, f_data in pairs(factory_data.uses_parts) do
						if tweak_data.weapon.factory.parts[f_data] then
							local __d = tweak_data.weapon.factory.parts[f_data]
							if __d.sub_type == "ammo_dragons_breath" and __d.custom_stats and __d.custom_stats.fire_dot_data then
								self.__ammo_poison = f_data
							elseif __d.sub_type == "ammo_explosive" and __d.custom_stats and tostring(__d.custom_stats.bullet_class) == "InstantExplosiveBulletBase" then
								self.__ammo_explosive = f_data
							elseif __d.sub_type == "ammo_slug" and __d.custom_stats and (__d.custom_stats.can_shoot_through_shield or __d.custom_stats.can_shoot_through_wall or __d.custom_stats.armor_piercing_add ) then
								self.__ammo_AP = f_data
							end
						end
					end
				end
			end
		end
	end
	return
end

function RRModTest002:GetBLTKeybind(id,...)
	if HoldTheKey and HoldTheKey.Get_BLT_Keybind then 
		return HoldTheKey:Get_BLT_Keybind(id,...)
	else
		for k,v in pairs(BLT.Keybinds._keybinds) do
			if type(v) == "table" then
				if v["_id"] == id then
					if v["_key"] and v["_key"]["pc"] then
						return tostring(v["_key"]["pc"])
					else
						return
					end
				end
			end
		end
		
		if BLT.Keybinds._potential_keybinds then
			for k,v in pairs(BLT.Keybinds._potential_keybinds) do
				if type(v) == "table" then
					if v["id"] == id then
						if v["pc"] then 
							return tostring(v["pc"])
						else
							return
						end
					end
				end
			end
		end
	end
end

function RRModTest002:RefreshKeybinds()
	self:SetOpenMenuKeybind(self:GetBLTKeybind("rrmodtest002_open_menu"))
end

function RRModTest002:MenuShouldClickOnRelease()
	return self.settings.menu_click_on_release
end

function RRModTest002:SetMouseClickOnMenuClose(value)
	self.settings.menu_click_on_release = value
end

function RRModTest002:GetOpenMenuKeybind()
	return self.settings.rrmodtest002_open_menu
end

function RRModTest002:SetOpenMenuKeybind(key)
	self.settings.rrmodtest002_open_menu = key
end

function RRModTest002:_create_panel(unit)
	local width = self.tweakdata.ws_w
	local height = self.tweakdata.ws_h
	local pos = unit:position()
	local offset_vector = Vector3(0,0,0) + pos
	local right_vector = Vector3(0, -width, 0)
	local bottom_vector = Vector3(0, 0, -height)
	
	if self._gui then 
		local new_ws = self._gui:create_world_workspace(width,height,offset_vector,right_vector,bottom_vector)
		return new_ws
	end
end

function RRModTest002:_remove_ws(ws)
	if ws then 
		self._gui:destroy_workspace(ws)
	end
end

function RRModTest002:_button_held(key)
	if HoldTheKey then
		return HoldTheKey:Key_Held(key)
	end

	if not (managers and managers.hud) or managers.hud._chat_focus then
		return false
	end
	
	key = tostring(key)
	if key:find("mouse ") then 
		if not key:find("wheel") then 
			key = key:sub(7)
		end
		return Input:mouse():down(Idstring(key))
	else
		return Input:keyboard():down(Idstring(key))
	end
end

function RRModTest002:Update(t, dt)
	if self:UsingRightWeapon() then
		local player = managers.player:local_player()
		if player then
			local action_radial = self.action_radial
			if action_radial then 
				if self:_button_held(self:GetOpenMenuKeybind()) then 
					if not action_radial:active() then 
						action_radial:Show()
					end
				elseif action_radial:active() then
					if self:MenuShouldClickOnRelease() then
						action_radial:mouse_clicked(action_radial._base,Idstring("0"),0,0)
					end
					action_radial:Hide()
				end
			end
		end
		local wep_base = self:UsingRightWeapon()
		if self.__next_weapon_dt then
			self.__next_weapon_dt = self.__next_weapon_dt - dt
			if self.__next_weapon_dt < 0 then
				self.__next_weapon_dt = nil
				if type(self.__next_weapon) == type(self.__now_weapon) and self.__next_weapon ~= self.__now_weapon then
					self.__now_weapon = self.__next_weapon
					self.__weapon_ammo[wep_base:get_name_id()] = self.__weapon_ammo[wep_base:get_name_id()] or {}
					self.__weapon_ammo[wep_base:get_name_id()][self.__next_weapon] = self.__weapon_ammo[wep_base:get_name_id()][self.__next_weapon] or 1
					wep_base:set_ammo(math.max(self.__weapon_ammo[wep_base:get_name_id()][self.__next_weapon], 0))
					wep_base:set_ammo_remaining_in_clip(0)
					managers.hud:set_ammo_amount(wep_base:selection_index(), wep_base:ammo_info())
				end
			end
		end
	end
end

function RRModTest002:SelectAmmo(ammo)
	if not self:UsingRightWeapon() then
		return
	end
	local ply = managers.player:local_player()
	local ply_inv = ply:inventory()
	local wep_base = self:UsingRightWeapon()
	local wep_blueprint = wep_base._blueprint
	local old_one
	local __new_wep_blueprint = function(__blueprint, use_this, del_this1, del_this2, del_this3)
		local __return_blueprint, __replaced = __blueprint, false
		if not table.contains(__blueprint, use_this) then
			for i, d in pairs(__blueprint) do
				if d == del_this1 or d == del_this2 or d == del_this3 then
					__blueprint[i] = use_this
					__return_blueprint = __blueprint
					__replaced = true
				end
			end
			if not __replaced then
				table.insert(__return_blueprint, use_this)
			end
		end
		return __return_blueprint, old_one
	end
	if table.contains(wep_blueprint, self.__ammo_poison) then
		self.__now_weapon = "poison"
	elseif table.contains(wep_blueprint, self.__ammo_explosive) then
		self.__now_weapon = "explosion"
	elseif table.contains(wep_blueprint, self.__ammo_AP) then
		self.__now_weapon = "AP"
	else
		self.__now_weapon = "standard"
	end
	self.__weapon_ammo[wep_base:get_name_id()] = self.__weapon_ammo[wep_base:get_name_id()] or {}
	self.__weapon_ammo[wep_base:get_name_id()][self.__now_weapon] = wep_base:get_ammo_total() / wep_base:get_ammo_max()
	if ammo == "standard" then
		wep_blueprint = __new_wep_blueprint(wep_blueprint, self.__ammo_standard, self.__ammo_explosive, self.__ammo_poison, self.__ammo_AP)
	elseif ammo == "poison" then
		wep_blueprint = __new_wep_blueprint(wep_blueprint, self.__ammo_poison, self.__ammo_standard, self.__ammo_explosive, self.__ammo_AP)
	elseif ammo == "explosion" then
		wep_blueprint = __new_wep_blueprint(wep_blueprint, self.__ammo_explosive, self.__ammo_standard, self.__ammo_poison, self.__ammo_AP)
	elseif ammo == "AP" then
		wep_blueprint = __new_wep_blueprint(wep_blueprint, self.__ammo_AP, self.__ammo_standard, self.__ammo_poison, self.__ammo_explosive)
	else
		return
	end
	if wep_blueprint then
		self.__next_weapon = ammo
		ply_inv:add_unit_by_factory_name(wep_base._factory_id, true, false, wep_blueprint, wep_base._cosmetics_data, wep_base._textures)
		self.__next_weapon_dt = 0.3
	end
end

function RRModTest002:SetActionMenu(menu)
	if not managers.hud then 
		return
	end
	self.action_radial = menu or self.action_radial
	managers.hud:add_updator("F_"..Idstring("RRModTest002:Update"):key(), callback(self, self, "Update"))
	self._gui = World:newgui()
end

function RRModTest002:Load()
	local file = io.open(self._save_path, "r")
	if (file) then
		for k, v in pairs(json.decode(file:read("*all"))) do
			self.settings[k] = v
		end
	else
		self:Save()
	end
end

function RRModTest002:Save()
	local file = io.open(self._save_path,"w+")
	if file then
		file:write(json.encode(self.settings))
		file:close()
	end
end

Hooks:Add("LocalizationManagerPostInit", "F_"..Idstring("RRModTest002:Loc"):key(), function( loc )
	local langFile = "english.txt"
	loc:load_localization_file(RRModTest002._path .. "loc/" .. langFile)
end)

Hooks:Add("MenuManagerInitialize", "F_"..Idstring("RRModTest002:MenuInit"):key(), function(menu_manager)
	MenuCallbackHandler.callback_RRModTest002_open_menu = function(self)
		if RRModTest002.action_radial then 
			RRModTest002.action_radial:Toggle()
		end
	end
	MenuCallbackHandler.callback_RRModTest002_close = function(self)
		RRModTest002:Save()
	end
	RRModTest002:Load()
end)

if PlayerInventory then
	Hooks:PostHook(PlayerInventory, '_call_listeners', "F_"..Idstring("RRModTest002:RadialMouseMenu:Init"):key(), function(self, event)
		if tostring(event) == "equip" then
			RRModTest002:RefreshKeybinds()
			RRModTest002:InitWeaponArrowData()
			if true then
				local __items = {}
				table.insert(__items, {
					text = managers.localization:text("rrmodtest002_ammo_standard"),
					icon = {
						texture = tweak_data.hud_icons.wp_arrow.texture,
						texture_rect = tweak_data.hud_icons.wp_arrow.texture_rect,
						layer = 3,
						w = 16,
						h = 16,
						alpha = 0.7,
						color = Color.yellow
					},
					show_text = true,
					stay_open = false,
					callback =  callback(RRModTest002, RRModTest002, "SelectAmmo", "standard")
				})
				if RRModTest002.__ammo_poison then
					table.insert(__items, {
						text = managers.localization:text("bm_wp_upg_a_dragons_breath"),
						icon = {
							texture = tweak_data.hud_icons.wp_arrow.texture,
							texture_rect = tweak_data.hud_icons.wp_arrow.texture_rect,
							layer = 3,
							w = 16,
							h = 16,
							alpha = 0.7,
							color = Color.green
						},
						show_text = true,
						stay_open = false,
						callback =  callback(RRModTest002, RRModTest002, "SelectAmmo", "poison")
					})
				end
				if RRModTest002.__ammo_explosive then
					table.insert(__items, {
						text = managers.localization:text("bm_wp_upg_a_explosive"),
						icon = {
							texture = tweak_data.hud_icons.wp_arrow.texture,
							texture_rect = tweak_data.hud_icons.wp_arrow.texture_rect,
							layer = 3,
							w = 16,
							h = 16,
							alpha = 0.7,
							color = Color.red
						},
						show_text = true,
						stay_open = false,
						callback = callback(RRModTest002, RRModTest002, "SelectAmmo", "explosion")
					})
				end
				if RRModTest002.__ammo_AP then
					table.insert(__items, {
						text = managers.localization:text("bm_wp_upg_a_slug"),
						icon = {
							texture = tweak_data.hud_icons.wp_arrow.texture,
							texture_rect = tweak_data.hud_icons.wp_arrow.texture_rect,
							layer = 3,
							w = 16,
							h = 16,
							alpha = 0.7,
							color = Color.white
						},
						show_text = true,
						stay_open = false,
						callback = callback(RRModTest002, RRModTest002, "SelectAmmo", "AP")
					})
				end
				RadialMouseMenu:new({
					name = managers.localization:text("RRModTest002_menu_title"),
					radius = 200,
					deadzone = 50,
					items = __items
				},callback(RRModTest002,RRModTest002,"SetActionMenu"))
			end
		end
	end)
end
