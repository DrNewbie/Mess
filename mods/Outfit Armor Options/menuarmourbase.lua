local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local __Name = function(__id)
	return "OAOs_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end
local ThisModSave = SavePath .. __Name("Outfit-Armor-Options") .. ".json"
local Hook1 = __Name("update_character_visual_state")

local __ThisOptionsSave = {["___"] = true}

local ThisModMenuID = __Name("ThisModMenuID")
local ThisModMenuTitle = __Name("menu_title")
local ThisModMenuDesc = __Name("menu_desc")
local ThisModMenuNoDesc = __Name("menu_desc_empty")

local function __Save()
    local __file = io.open(ThisModSave, "w+")
    if __file then
        __file:write(json.encode(__ThisOptionsSave))
        __file:close()
    end
	return
end

local function __Load()
	local __file = io.open(ThisModSave, "r")
	if __file then
		for __k, __v in pairs(json.decode(__file:read("*all")) or {}) do
			__ThisOptionsSave[__k] = __v
		end
		__file:close()
	else
		pcall(__Save)
	end
	return
end

Hooks:Add("LocalizationManagerPostInit", __Name("LocalizationManagerPostInit"), function(loc)
	LocalizationManager:add_localized_strings({
		[ThisModMenuTitle] = "Outfit Armor Options",
		[ThisModMenuDesc] = " ",
		[ThisModMenuNoDesc] = " ",
		[__Name("g_vest_small")] = "g_vest_small",
		[__Name("g_vest_body")] = "g_vest_body",
		[__Name("g_vest_neck")] = "g_vest_neck",
		[__Name("g_vest_shoulder")] = "g_vest_shoulder",
		[__Name("g_vest_thies")] = "g_vest_thies",
		[__Name("g_vest_leg_arm")] = "g_vest_leg_arm",
		[__Name("g_vest_enable")] = "Forced enable this part",
		[__Name("By Armor")] = "By Armor",
		[__Name("By Armor desc")] = "Override settings!! Using 'Armor' function, disable this if you want to use others"
	})
end)

Hooks:Add("MenuManagerSetupCustomMenus", __Name("MenuManagerSetupCustomMenus"), function()
	MenuHelper:NewMenu(ThisModMenuID)
	for __player_style, __data in pairs(tweak_data.blackmarket.player_styles) do
		if type(__data) == "table" and type(__data.name_id) == "string" then
			local __menu_id = __Name("menu_id::"..__player_style)
			MenuHelper:NewMenu(__menu_id)
		end
	end
end)

Hooks:Add("MenuManagerBuildCustomMenus", __Name("MenuManagerBuildCustomMenus"), function(menu_manager, nodes)
	nodes[ThisModMenuID] = MenuHelper:BuildMenu(ThisModMenuID)
	MenuHelper:AddMenuItem(nodes["blt_options"], ThisModMenuID, ThisModMenuTitle, ThisModMenuDesc)
	for __player_style, __data in pairs(tweak_data.blackmarket.player_styles) do
		if type(__data) == "table" and type(__data.name_id) == "string" then
			local __menu_id = __Name("menu_id::"..__player_style)
			nodes[__menu_id] = MenuHelper:BuildMenu(__menu_id)
			MenuHelper:AddMenuItem(nodes[ThisModMenuID], __menu_id, __data.name_id, ThisModMenuDesc)
		end
	end
end)

Hooks:Add("MenuManagerPopulateCustomMenus", __Name("MenuManagerPopulateCustomMenus"), function(menu_manager, nodes)
	local __list = {}
	local obj_g_vest = {
		"g_vest_small",
		"g_vest_body",
		"g_vest_neck",
		"g_vest_shoulder",
		"g_vest_thies",
		"g_vest_leg_arm"
	}
	for __player_style, __data in pairs(tweak_data.blackmarket.player_styles) do
		if type(__data) == "table" and type(__data.name_id) == "string" then
			local __menu_id = __Name("menu_id::"..__player_style)
			local __menu_callback = __Name("menu_callback::"..__player_style)			

			local priority = 100
			for _, __obj in pairs(obj_g_vest) do
				local __obj_menu_callback = __Name("obj::toggle::"..__obj.."::"..__player_style)
				local __obj_save = __Name("save::"..__obj.."::"..__player_style)
				MenuCallbackHandler[__obj_menu_callback] = function(self, item)
					__ThisOptionsSave[__obj_save] = tostring(item:value()) == "on" and true or false
					pcall(__Save)
				end
				MenuHelper:AddToggle({
					id = __Name("toggle::"..__obj_menu_callback),
					title = __Name(__obj),
					desc = __Name("g_vest_enable"),
					callback = __obj_menu_callback,
					menu_id = __menu_id,
					value = __ThisOptionsSave[__obj_save] and true or false,
					priority = priority
				})
				if type(__ThisOptionsSave[__obj_save]) ~= "boolean" then
					__ThisOptionsSave[__obj_save] = false
				end
				priority = priority - 1
			end
			local __obj_a_menu_callback = __Name("obj::toggle::armor::"..__player_style)
			local __obj_a_save = __Name("save::armor::"..__player_style)
			MenuCallbackHandler[__obj_a_menu_callback] = function(self, item)
				__ThisOptionsSave[__obj_a_save] = tostring(item:value()) == "on" and true or false
				pcall(__Save)
			end
			MenuHelper:AddToggle({
				id = __Name("toggle::armor"),
				title = __Name("By Armor"),
				desc = __Name("By Armor desc"),
				callback = __obj_a_menu_callback,
				menu_id = __menu_id,
				value = __ThisOptionsSave[__obj_a_save] and true or false,
				priority = priority
			})
			if type(__ThisOptionsSave[__obj_a_save]) ~= "boolean" then
				__ThisOptionsSave[__obj_a_save] = false
			end
			priority = priority - 1
		end
	end
	pcall(__Save)
end)

pcall(__Load)

--[[

	Apply

]]
if not MenuArmourBase then
	return
end

local Func1 = __Name("force_apply_armor")

MenuArmourBase[Func1] = MenuArmourBase[Func1] or function(self, ...)
	if not self._unit or not alive(self._unit) or not self._armor_id then
	
	else
		local obj_g_vest = {
			"g_vest_small",
			"g_vest_body",
			"g_vest_neck",
			"g_vest_shoulder",
			"g_vest_thies",
			"g_vest_leg_arm"
		}
		local player_style_id = self:player_style()		
		if player_style_id then
			local armor_part = {
				level_2 = {
					"g_vest_small"
				},
				level_3 = {
					"g_vest_body"
				},
				level_4 = {
					"g_vest_body",
					"g_vest_neck"
				},
				level_5 = {
					"g_vest_body",
					"g_vest_shoulder",
					"g_vest_neck"
				},
				level_6 = {
					"g_vest_body",
					"g_vest_shoulder",
					"g_vest_neck",
					"g_vest_thies"
				},
				level_7 = {
					"g_vest_body",
					"g_vest_shoulder",
					"g_vest_neck",
					"g_vest_thies",
					"g_vest_leg_arm"
				}
			}
			local opt_default = __Name("save::default::"..player_style_id)
			local opt_armor = __Name("save::armor::"..player_style_id)
			if __ThisOptionsSave[opt_armor] then
				local armor_id = self:armor_id()
				if armor_id then
					local armor_data = armor_part[armor_id]
					if armor_data then
						for _, __ids in pairs(armor_data) do
							if self._unit:get_object(Idstring(__ids)) then
								self._unit:get_object(Idstring(__ids)):set_visibility(true)
							end
						end
					end
				end
			else
				for _, __obj in pairs(obj_g_vest) do
					local opt_part = __Name("save::"..__obj.."::"..player_style_id)
					if __ThisOptionsSave[opt_part] then
						if self._unit:get_object(Idstring(__obj)) then
							self._unit:get_object(Idstring(__obj)):set_visibility(true)
						end
					end
				end
			end
		end
	end
end

Hooks:PostHook(MenuArmourBase, "_apply_cosmetics", __Name("_apply_cosmetics"), function(self, ...)
	call_on_next_update(callback(self, self, Func1))
end)

Hooks:PostHook(MenuArmourBase, "update_character_visuals", __Name("update_character_visuals"), function(self, ...)
	call_on_next_update(callback(self, self, Func1))
end)