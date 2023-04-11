local ThisModPath = ModPath

local __Name = function(__id)
	return "coj_"..Idstring(tostring(__id).."::"..ThisModPath):key()
end

local is_bool = __Name("is_bool")
local new_tree = __Name("new_tree")
local new_tree_bg_texture = __Name("new_tree_bg_texture")
local new_skill_1_11 = __Name("new_skill_1_11")
local new_skill_1_11_icon = __Name("new_skill_1_11_icon")
local press_reload_key_times = __Name("press_reload_key_times")

--[[
	localization
]]
Hooks:Add("LocalizationManagerPostInit", __Name("load_localization_file"), function(loc)
	loc:load_localization_file(ThisModPath.."localization/localization.json")
end)

--[[
	load assets
]]
local function __load_assets()
	BLTAssetManager:CreateEntry(
		Idstring(new_tree_bg_texture),
		Idstring("texture"),
		ThisModPath.."assets/skilltreebackground.texture",
		nil
	)
	BLTAssetManager:CreateEntry(
		Idstring(new_skill_1_11_icon),
		Idstring("texture"),
		ThisModPath.."assets/skillicon_1_11.texture",
		nil
	)
	return
end
pcall(__load_assets)

--[[
	skill tree gui tweak
]]
if NewSkillTreeGui and not NewSkillTreeGui[is_bool] then
	NewSkillTreeGui[is_bool] = true
	local function __new_skill_gui(them)
		local __tmp_bg_image = __Name("__tmp_bg_image")
		if type(them._active_page) == "number" then
			local active_tree = them._tree_items[them._active_page]
			local active_tab = them._tab_items[them._active_page]
			if them[__tmp_bg_image] then
				them._fullscreen_panel:remove(them[__tmp_bg_image])
			end
			if type(active_tree) == "table" and tostring(active_tree._page_name) == new_tree then
				them[__tmp_bg_image] = them._fullscreen_panel:bitmap({
					name = __tmp_bg_image,
					texture = new_tree_bg_texture,
					w = them._fullscreen_panel:w(),
					h = them._fullscreen_panel:h(),
					layer = 1,
					blend_mode = "add",
					alpha = 0.4,
					visible = true
				})
			end
		end
	end
	Hooks:PostHook(NewSkillTreeGui, "set_active_page", __Name("NewSkillTreeGui"), function(self, ...)
		pcall(__new_skill_gui, self)
	end)

	local function __new_skill_icons(them)
		local skill_id = them._skill_id
		local skill_data = tweak_data.skilltree.skills[skill_id]
		local skill_icon_panel = them._skill_panel:child("SkillIconPanel")
		if skill_icon_panel and alive(skill_icon_panel) and type(skill_data) == "table" and type(skill_data.__icon) == "string" then
			local icon = skill_icon_panel:child("Icon")
			if icon and alive(icon) then
				local __current_size = them._current_size
				if them._icon then
					skill_icon_panel:remove(them._icon)
				end
				them._icon = skill_icon_panel:bitmap({
					texture = skill_data.__icon,
					name = "Icon",
					blend_mode = "add",
					layer = 1,
					visible = true
				})
				them._icon:set_size(__current_size, __current_size)
				them._icon:set_center(skill_icon_panel:w() / 2, skill_icon_panel:h() / 2)
			end
		end
	end
	Hooks:PostHook(NewSkillTreeSkillItem, "refresh", __Name("NewSkillIcons"), function(self, ...)
		pcall(__new_skill_icons, self)
	end)
end

--[[
	skill tree tweak
]]
if SkillTreeTweakData and not SkillTreeTweakData[is_bool] then
	SkillTreeTweakData[is_bool] = true
	Hooks:PostHook(SkillTreeTweakData, "init", __Name("SkillTreeTweakData"), function(self, ...)
		self.skill_pages_order[#self.skill_pages_order+1] = new_tree
		self.skilltree[new_tree] = {
			name_id = "coj_tree00000_title",
			desc_id = "coj_tree00000_desc"
		}
		self.skills[new_skill_1_11] = {
			["name_id"] = "coj_tree00000_1_11_name",
			["desc_id"] = "coj_tree00000_1_11_desc",
			["__icon"] = new_skill_1_11_icon,
			[1] = {
				upgrades = {
					"player_coj_guns_lazing_1"
				},
				cost = self.costs.hightierpro
			}
			--[[,
			[2] = {
				upgrades = {
				
				},
				cost = self.costs.pro
			}
			]]
		}
		table.insert(self.trees,{
			name_id = "coj_tree00000_tree1_name",
			background_texture = "guis/textures/pd2/skilltree/bg_mastermind",
			unlocked = true,
			skill = new_tree,
			tiers = {
				{	
					new_skill_1_11
				}
			}
		})	
	end)
end

--[[
	skill tweak
]]
if UpgradesTweakData and not UpgradesTweakData[is_bool] then
	UpgradesTweakData[is_bool] = true
	Hooks:PostHook(UpgradesTweakData, "_player_definitions", __Name("UpgradesTweakData"), function(self)
		self.values.player.coj_guns_blazing_1 = {
			{
				require_times = 7
			}
		}
		self.definitions.player_coj_guns_lazing_1 = {
			name_id = "menu_player_coj_guns_blazing_1",
			category = "feature",
			upgrade = {
				value = 1,
				upgrade = "coj_guns_blazing_1",
				category = "player"
			}
		}
	end)
end

--[[
	press_reload_key_times / require_times = possible
	ex: press 3 times, 3/7 = 42.86% to do faster reload
]]
if NewRaycastWeaponBase and not NewRaycastWeaponBase[is_bool] then
	NewRaycastWeaponBase[is_bool] = true
	local old_reload_speed_multiplier = NewRaycastWeaponBase.reload_speed_multiplier
	function NewRaycastWeaponBase:reload_speed_multiplier(...)
		local ans = old_reload_speed_multiplier(self, ...)
		if ans and managers.player:has_category_upgrade("player", "coj_guns_blazing_1") then
			local var = managers.player:upgrade_value("player", "coj_guns_blazing_1")
			if type(var) == "table" and type(var.require_times) == "number" and self:weapon_tweak_data().__is_guns_blazing_skill then
				local press_times = managers.player[press_reload_key_times] or 0
				local possible_rng = math.clamp(press_times/var.require_times, 0, 1)
				--[[
					press more times = more chance to do fast reload
				]]
				if possible_rng >= math.random() then
					self:set_ammo_remaining_in_clip(math.min(self:get_ammo_max_per_clip(), self:get_ammo_remaining_in_clip() + 1))
				end
				math.random()
				math.random()
				math.random()
				math.random()
				math.random()
			end
		end
		managers.player[press_reload_key_times] = 0
		return ans
	end
end

--[[
	weapon tweak , '__is_guns_blazing_skill'
]]
if WeaponTweakData and not WeaponTweakData[is_bool] then
	WeaponTweakData[is_bool] = true
	Hooks:PostHook(WeaponTweakData, "_init_peacemaker", __Name("_init_peacemaker"), function(self, ...)
		self.peacemaker.__is_guns_blazing_skill = true
	end)
	
	Hooks:PostHook(WeaponTweakData, "_init_winchester1874", __Name("_init_winchester1874"), function(self, ...)
		self.winchester1874.__is_guns_blazing_skill = true
	end)
end

--[[
	press_reload_key_times + 1 when using right weapon and reloading
]]
if PlayerManager and not PlayerManager[is_bool] then
	PlayerManager[is_bool] = true
	local function __check_press_reload_key(them)
		local local_player = them:local_player()
		local controller = local_player:base():controller()
		local current_state = them:get_current_state()
		if controller and current_state:_is_reloading() and controller:get_input_pressed("reload") then
			local equipped_unit = current_state._equipped_unit
			if equipped_unit:base() and equipped_unit:base():can_reload() and equipped_unit:base():weapon_tweak_data().__is_guns_blazing_skill then
				them[press_reload_key_times] = them[press_reload_key_times] or 0
				them[press_reload_key_times] = them[press_reload_key_times] + 1
			end
		end
	end
	Hooks:PostHook(PlayerManager, "update", __Name("loop check press reload key"), function(self, ...)
		if self:local_player() and self:get_current_state() then
			pcall(__check_press_reload_key, self)
		end
	end)
end