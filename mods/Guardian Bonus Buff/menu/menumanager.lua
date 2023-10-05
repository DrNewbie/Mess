local ThisModPath = ModPath

_G.GuardianBonusBuff = _G.GuardianBonusBuff or {}

GuardianBonusBuff.ModPath = GuardianBonusBuff.ModPath or ThisModPath

GuardianBonusBuff.SavePath = SavePath.."GuardianBonusBuff.txt"

GuardianBonusBuff._data = GuardianBonusBuff._data or {}

GuardianBonusBuff.Settings = GuardianBonusBuff.Settings or {}

function GuardianBonusBuff:Default()
	return {
		increase_maximum_health = 0,
		increase_maximum_health__max_level_max = 20,
		increase_maximum_armor = 0,
		increase_maximum_armor__max_level_max = 20,
		increase_addon_critical = 0,
		increase_addon_critical__max_level_max = 20,
		increase_addon_dodge = 0,
		increase_addon_dodge__max_level_max = 20,
		increase_addon_weapon_switch_speed = 0,
		increase_addon_weapon_switch_speed__max_level_max = 20,
		increase_addon_weapon_damage_multiplier = 0,
		increase_addon_weapon_damage_multiplier__max_level_max = 20,
		increase_addon_pick_up_ammo_multiplier = 0,
		increase_addon_pick_up_ammo_multiplier__max_level_max = 5,
		increase_addon_armor_regen_time_mul = 0,
		increase_addon_armor_regen_time_mul__max_level_max = 20,
		increase_crouch_speed_multiplier = 0,
		increase_crouch_speed_multiplier__max_level_max = 5,
		increase_stamina_multiplier = 0,
		increase_stamina_multiplier__max_level_max = 10,
		increase_interaction_speed_multiplier = 0,
		increase_interaction_speed_multiplier__max_level_max = 30,
		increase_reload_speed_multiplier = 0,
		increase_reload_speed_multiplier__max_level_max = 30
	}
end

function GuardianBonusBuff:save()
	local _file = io.open(self.SavePath, "w+")
	if _file then
		_file:write(json.encode(self.Settings))
		_file:close()
	end
end

function GuardianBonusBuff:reset()
	self.Settings = self:Default()
	self:save()
end

function GuardianBonusBuff:load()
	self.Settings = self:Default()
	local _file = io.open(self.SavePath, "r")
	if _file then
		for k, v in pairs(json.decode(_file:read("*all")) or {}) do
			if k and not k:find('max_level_max') and self:Default()[k] and type(self:Default()[k]) == type(v) then
				self.Settings[k] = math.min(v, self:Default()[k.."__max_level_max"])
			end
		end
		_file:close()
	else
		self:reset()
	end
	self:save()
end

GuardianBonusBuff:load()

function GuardianBonusBuff:IsGuardianOK(__buff_name)
	if type(__buff_name) ~= "string" or type(self:Default()[__buff_name]) ~= "number" then
		return nil
	else
		return self.Settings[__buff_name]
	end
end

function GuardianBonusBuff:GetReqCoinAmount(__buff_name, __lv)
	if not self:IsGuardianOK(__buff_name) then
		return 0
	end
	--[[
	__lv =__lv or self.Settings[__buff_name]
	return math.round(math.exp(__lv))
	]]
	return 1
end

function GuardianBonusBuff:GetNextLevelReqCoinAmount(__buff_name, __lv)
	if not self:IsGuardianOK(__buff_name) then
		return 0
	end
	--[[
	__lv =__lv or self.Settings[__buff_name]
	__lv = __lv + 1
	return math.round(math.exp(__lv))
	]]
	return 1
end

function GuardianBonusBuff:GetCoinUsed()
	local __def_var = self:Default()
	local __used_point = 0
	for __i, __v in pairs(__def_var) do
		if __i and not __i:find('max_level_max') then
			__used_point = __used_point + self.Settings[__i]
		end
	end
	return __used_point
end

function GuardianBonusBuff:GetCoinHave()
	if managers.experience then
		return math.max(managers.experience:current_rank() - self:GetCoinUsed(), 0)
	else
		return 0
	end
end

function GuardianBonusBuff:IsCoinEnough(__buff_name, __lv)
	if not self:IsGuardianOK(__buff_name) or not managers.experience then
		return
	end
	--[[
	if managers.custom_safehouse:coins() > self:GetNextLevelReqCoinAmount(__buff_name, __lv) then
		return true
	else
		return false
	end
	]]
	if self:GetCoinUsed() > managers.experience:current_rank() then
		return false
	else
		return true
	end
end

function GuardianBonusBuff:GetBonusPercent(__buff_name, __lv)
	if not self:IsGuardianOK(__buff_name) then
		return 0
	end
	__lv =__lv or self.Settings[__buff_name]
	if __lv <= 0 then
		return 0
	end
	return self:GetBonusPrePercent(__buff_name, __lv)/100
end

function GuardianBonusBuff:GetBonusPrePercent(__buff_name, __lv)
	if not self:IsGuardianOK(__buff_name) then
		return 0
	end
	__lv =__lv or self.Settings[__buff_name]
	if __lv <= 0 then
		return 0
	end
	if __buff_name == "increase_addon_weapon_switch_speed" then
		return math.round( __lv*7.5 ) / 5
	elseif __buff_name == "increase_addon_weapon_damage_multiplier" then
		return math.round( __lv*7.5 ) / 5
	elseif __buff_name == "increase_addon_pick_up_ammo_multiplier" then
		return math.round( __lv*20 )
	elseif __buff_name == "increase_crouch_speed_multiplier" then
		return math.round( __lv*10 )
	elseif __buff_name == "increase_stamina_multiplier" then
		return math.round( __lv*7.5 ) / 5 * 2
	elseif __buff_name == "increase_interaction_speed_multiplier" then
		return math.round( __lv*7.5 ) / 5
	elseif __buff_name == "increase_reload_speed_multiplier" then
		return __lv
	end
	return math.round( __lv*7.5 ) / 10
end

function GuardianBonusBuff:ReachMaxLevel(__buff_name, __lv)
	if not self:IsGuardianOK(__buff_name) then
		return 0
	end
	if self.Settings[__buff_name] >= self:Default()[__buff_name.."__max_level_max"] then
		return 1
	end
	if __lv and __lv >= self:Default()[__buff_name.."__max_level_max"] then
		return 1
	end
	return 2
end

function GuardianBonusBuff:GetLevelUpgradeDesc(__buff_name, __lv)
	local __old_desc = self.__loc:text("Guardian_"..__buff_name.."_name")
	local __new_perc = self:GetBonusPrePercent(__buff_name, __lv)
	local __lv_now = self:ReachMaxLevel(__buff_name) == 1 and "Max" or (__lv or self:IsGuardianOK(__buff_name))
	return string.upper(__old_desc.." + "..__new_perc.." %".." (Lv."..__lv_now..")")
end

function GuardianBonusBuff:DoLocUpgrade()
	if not self.__loc then
		log("GuardianBonusBuff: Error.500")
		return
	end
	for __buff_name, _ in pairs(self:Default()) do
		if not __buff_name:find("__max_level_max") then
			self.__loc:add_localized_strings({
				["Guardian_"..__buff_name.."_name_w_var"] = self:GetLevelUpgradeDesc(__buff_name)
			})
		end
	end
end

function GuardianBonusBuff:DoUpgrade(data)
	local __buff_name = data.__buff_name
	local __req_coin = data.__req_coin
	--managers.custom_safehouse:deduct_coins(__req_coin)
	local __old_desc =  self:GetLevelUpgradeDesc(__buff_name, self.Settings[__buff_name])
	local __new_desc = self:GetLevelUpgradeDesc(__buff_name, self.Settings[__buff_name] + 1)
	self.Settings[__buff_name] = self.Settings[__buff_name] + 1
	self:save()
	self:DoLocUpgrade()
	local __text = __old_desc.." -> \n"..__new_desc
	QuickMenu:new(
		managers.localization:to_upper_text("GuardianBonusBuff_menu_title"),
		__text,
		{{text = "Ok", is_cancel_button = true}},
		true
	):Show()
end

function GuardianBonusBuff:AskUpgrade(__buff_name)
	if not managers.system_menu then
		log("GuardianBonusBuff: Error.400")
		return
	end
	if not self:IsGuardianOK(__buff_name) then
		QuickMenu:new(
			managers.localization:to_upper_text("GuardianBonusBuff_menu_title"),
			"Error.1",
			{{text = "Ok", is_cancel_button = true}},
			true
		):Show()
		return
	end
	local __check_level = self:ReachMaxLevel(__buff_name)
	if __check_level == 0 then
		QuickMenu:new(
			managers.localization:to_upper_text("GuardianBonusBuff_menu_title"),
			"Error.2",
			{{text = "Ok", is_cancel_button = true}},
			true
		):Show()
		return
	elseif __check_level == 1 then
		QuickMenu:new(
			managers.localization:to_upper_text("GuardianBonusBuff_menu_title"),
			managers.localization:to_upper_text("GuardianBonusBuff_no_more_upgrade"),
			{{text = "Ok", is_cancel_button = true}},
			true
		):Show()
		return
	elseif __check_level == 2 then
	
	else
		QuickMenu:new(
			managers.localization:to_upper_text("GuardianBonusBuff_menu_title"),
			"Error.3",
			{{text = "Ok", is_cancel_button = true}},
			true
		):Show()
		return
	end
	if not self:IsCoinEnough(__buff_name) then
		QuickMenu:new(
			managers.localization:to_upper_text("GuardianBonusBuff_menu_title"),
			"You don't have enough coins. (Require: ".. self:GetNextLevelReqCoinAmount(__buff_name) .. ")",
			{{text = "Ok", is_cancel_button = true}},
			true
		):Show()
		return
	end	
	local __level = self:IsGuardianOK(__buff_name)
	local __txt = managers.localization:to_upper_text("GuardianBonusBuff_ready_to_upgrade")
	__txt = __txt .. "\n" .. "[ Level "..__level.." --> "..(__level+1).." ]"
	local __old_desc =  self:GetLevelUpgradeDesc(__buff_name, self.Settings[__buff_name])
	local __new_desc = self:GetLevelUpgradeDesc(__buff_name, self.Settings[__buff_name] + 1)
	__txt = __txt .. "\n" .. __old_desc .. " -> \n" .. __new_desc
	__txt = __txt .. "\n"
	__txt = __txt .. "\n" .. "[ Req. Coin: "..self:GetNextLevelReqCoinAmount(__buff_name, __lv).." ]"
	__txt = __txt .. "\n" .. "[ Coin you have: "..self:GetCoinHave().." ]"
	managers.system_menu:show({
		title = managers.localization:to_upper_text("GuardianBonusBuff_menu_title"),
		text = __txt,
		button_list = {
			{text = "No", is_cancel_button = true},
			{text = "Yes", callback_func = callback(self, self, "DoUpgrade", {__buff_name = __buff_name, __req_coin = self:GetNextLevelReqCoinAmount(__buff_name, __lv)})}
		},
		id = "F_"..Idstring(tostring(math.random(0,0xFFFFFFFF))):key()
	})
end

Hooks:Add("LocalizationManagerPostInit", "M_"..Idstring("LocalizationManagerPostInit:GuardianBonusBuff"):key(), function(loc)
	loc:load_localization_file(GuardianBonusBuff.ModPath.."loc/def_loc.json")
	GuardianBonusBuff.__loc = loc
	GuardianBonusBuff:DoLocUpgrade()
end)

Hooks:Add("MenuManagerInitialize", "M_"..Idstring("MenuManagerInitialize:GuardianBonusBuff"):key(), function()
	MenuCallbackHandler.DoResetFunc = function(self)
		GuardianBonusBuff:reset()
		GuardianBonusBuff:DoLocUpgrade()
	end
	MenuCallbackHandler.callback_Guardian_Func_reset = function(self)
		managers.system_menu:show({
			title = managers.localization:to_upper_text("Guardian_Func_reset_name"),
			text = managers.localization:to_upper_text("Guardian_Func_reset_desc"),
			button_list = {
				{text = "No", is_cancel_button = true},
				{text = "Yes", callback_func = callback(self, self, "DoResetFunc", {})}
			},
			id = "F_"..Idstring(tostring(math.random(0,0xFFFFFFFF))):key()
		})
	end
	MenuCallbackHandler.callback_Guardian_increase_maximum_health = function(self)
		GuardianBonusBuff:AskUpgrade("increase_maximum_health")
	end
	MenuCallbackHandler.callback_Guardian_increase_maximum_armor = function(self)
		GuardianBonusBuff:AskUpgrade("increase_maximum_armor")
	end
	MenuCallbackHandler.callback_Guardian_increase_addon_critical = function(self)
		GuardianBonusBuff:AskUpgrade("increase_addon_critical")
	end
	MenuCallbackHandler.callback_Guardian_increase_addon_dodge = function(self)
		GuardianBonusBuff:AskUpgrade("increase_addon_dodge")
	end
	MenuCallbackHandler.callback_Guardian_increase_addon_weapon_switch_speed = function(self)
		GuardianBonusBuff:AskUpgrade("increase_addon_weapon_switch_speed")
	end
	MenuCallbackHandler.callback_Guardian_increase_addon_weapon_damage_multiplier = function(self)
		GuardianBonusBuff:AskUpgrade("increase_addon_weapon_damage_multiplier")
	end
	MenuCallbackHandler.callback_Guardian_increase_addon_pick_up_ammo_multiplier = function(self)
		GuardianBonusBuff:AskUpgrade("increase_addon_pick_up_ammo_multiplier")
	end
	MenuCallbackHandler.callback_Guardian_increase_addon_armor_regen_time_mul = function(self)
		GuardianBonusBuff:AskUpgrade("increase_addon_armor_regen_time_mul")
	end
	MenuCallbackHandler.callback_Guardian_increase_crouch_speed_multiplier = function(self)
		GuardianBonusBuff:AskUpgrade("increase_crouch_speed_multiplier")
	end
	MenuCallbackHandler.callback_Guardian_increase_stamina_multiplier = function(self)
		GuardianBonusBuff:AskUpgrade("increase_stamina_multiplier")
	end
	MenuCallbackHandler.callback_Guardian_increase_interaction_speed_multiplier = function(self)
		GuardianBonusBuff:AskUpgrade("increase_interaction_speed_multiplier")
	end
	MenuCallbackHandler.callback_Guardian_increase_reload_speed_multiplier = function(self)
		GuardianBonusBuff:AskUpgrade("increase_reload_speed_multiplier")
	end
	MenuHelper:LoadFromJsonFile(GuardianBonusBuff.ModPath.."menu/menu.json", GuardianBonusBuff, GuardianBonusBuff._data)
end)

GuardianBonusBuff:DoLocUpgrade()