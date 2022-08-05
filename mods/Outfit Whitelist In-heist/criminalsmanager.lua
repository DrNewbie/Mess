local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local ThisModSave = SavePath .. "Outfit-Whitelist-In-heist.json"
local __Name = function(__id)
	return "OWI_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end
local Hook1 = __Name("update_character_visual_state")
local Bool1 = __Name("Bool1")

local __BypassThisHeist = {["___"] = true}

if CriminalsManager then
	Hooks:PostHook(CriminalsManager, "update_character_visual_state", Hook1, function(self, __character_name, __visual_state, ...)
		if type(__character_name) == "string" and type(__visual_state) == "table" and managers.job and not __visual_state[Bool1] and Utils and (Utils:IsInGameState() or Utils:IsInHeist() or Utils:IsInCustody()) then
			__visual_state[Bool1] = true
			if not __BypassThisHeist[tostring(__visual_state.player_style)] then
				local __player_style = managers.blackmarket:get_default_player_style()
				local __current_level = managers.job:current_level_id()
				if __current_level and tweak_data.levels[__current_level] and tweak_data.levels[__current_level].player_style then
					__player_style = tweak_data.levels[__current_level].player_style
				end
				__visual_state.player_style = __player_style
				__visual_state.glove_id = managers.blackmarket:get_default_glove_id()
				self:update_character_visual_state(__character_name, __visual_state, ...)
			end
		end
	end)
end

local ThisModMenuID = __Name("ThisModMenuID")
local ThisModMenuTitle = __Name("menu_title")
local ThisModMenuDesc = __Name("menu_desc")
local ThisModMenuNoDesc = __Name("menu_desc_empty")

local function __Save()
    local __file = io.open(ThisModSave, "w+")
    if __file then
        __file:write(json.encode(__BypassThisHeist))
        __file:close()
    end
	return
end

local function __Load()
	local __file = io.open(ThisModSave, "r")
	if __file then
		for __k, __v in pairs(json.decode(__file:read("*all")) or {}) do
			__BypassThisHeist[__k] = __v
		end
		__file:close()
	else
		__Save()
	end
	return
end

Hooks:Add("LocalizationManagerPostInit", __Name("LocalizationManagerPostInit"), function(loc)
	LocalizationManager:add_localized_strings({
		[ThisModMenuTitle] = "Outfit Whitelist In-heist",
		[ThisModMenuDesc] = " ",
		[ThisModMenuNoDesc] = " "
	})
end)

Hooks:Add("MenuManagerSetupCustomMenus", __Name("MenuManagerSetupCustomMenus"), function()
	MenuHelper:NewMenu(ThisModMenuID)
end)

Hooks:Add("MenuManagerBuildCustomMenus", __Name("MenuManagerBuildCustomMenus"), function(menu_manager, nodes)
	nodes[ThisModMenuID] = MenuHelper:BuildMenu(ThisModMenuID)
	MenuHelper:AddMenuItem(nodes["blt_options"], ThisModMenuID, ThisModMenuTitle, ThisModMenuDesc)
end)

Hooks:Add("MenuManagerPopulateCustomMenus", __Name("MenuManagerPopulateCustomMenus"), function(menu_manager, nodes)
	local __list = {}
	for __player_style, __data in pairs(tweak_data.blackmarket.player_styles) do
		if type(__data) == "table" and type(__data.name_id) == "string" then
			local __menu_id = __Name("menu_id::"..__player_style)
			local __menu_callback = __Name("menu_callback::"..__player_style)
			MenuCallbackHandler[__menu_callback] = function(self, item)
				__BypassThisHeist[__player_style] = tostring(item:value()) == "on" and true or false
				__Save()
			end
			MenuHelper:AddToggle({
				id = __menu_id,
				title = __data.name_id,
				desc = ThisModMenuNoDesc,
				callback = __menu_callback,
				menu_id = ThisModMenuID,
				value = __BypassThisHeist[__player_style] and true or false
			})
			if type(__BypassThisHeist[__player_style]) ~= "boolean" then
				__BypassThisHeist[__player_style] = false
			end
		end
	end
	__Save()
end)

__Load()