local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local ThisModSave = SavePath .. "Blacklist-Difficulty-from-Crime-Net.json"
local __Name = function(__id)
	return "BDCN_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end
local ThisModMenuID = __Name("ThisModMenuID")
local ThisModMenuTitle = __Name("menu_title")
local ThisModMenuDesc = __Name("menu_desc")
local ThisModMenuNoDesc = __Name("menu_desc_empty")

local __BlockThisDiff = {["___"] = true}

local function __Save()
    local __file = io.open(ThisModSave, "w+")
    if __file then
        __file:write(json.encode(__BlockThisDiff))
        __file:close()
    end
	return
end

local function __Load()
	local __file = io.open(ThisModSave, "r")
	if __file then
		for __k, __v in pairs(json.decode(__file:read("*all")) or {}) do
			__BlockThisDiff[__k] = __v
		end
		__file:close()
	else
		__Save()
	end
	return
end

Hooks:Add("LocalizationManagerPostInit", __Name("LocalizationManagerPostInit"), function(...)
	LocalizationManager:add_localized_strings({
		[ThisModMenuTitle] = "Blacklist Difficulty from Crime.Net",
		[ThisModMenuDesc] = " ",
		[ThisModMenuNoDesc] = " "
	})
end)

Hooks:Add("MenuManagerSetupCustomMenus", __Name("MenuManagerSetupCustomMenus"), function(...)
	MenuHelper:NewMenu(ThisModMenuID)
end)

Hooks:Add("MenuManagerBuildCustomMenus", __Name("MenuManagerBuildCustomMenus"), function(menu_manager, nodes)
	nodes[ThisModMenuID] = MenuHelper:BuildMenu(ThisModMenuID)
	MenuHelper:AddMenuItem(nodes["blt_options"], ThisModMenuID, ThisModMenuTitle, ThisModMenuDesc)
end)

Hooks:Add("MenuManagerPopulateCustomMenus", __Name("MenuManagerPopulateCustomMenus"), function(menu_manager, nodes)
	local __list = tweak_data.difficulties
	__list[1] = nil --remove 'easy'
	--Give OD name
	for __p, __diff in pairs(__list) do
		local diff_name_id = tweak_data.difficulty_name_ids[__diff]
		local od_diff_name_id = diff_name_id.."_one_down"
		LocalizationManager:add_localized_strings({
			[od_diff_name_id] = managers.localization:text(diff_name_id)..", "..managers.localization:text("menu_one_down")
		})
	end
	--Create Opts
	for __p, __diff in pairs(__list) do
		local __menu_id = __Name("menu_id::"..__diff)
		local __menu_callback = __Name("menu_callback::"..__diff)
		MenuCallbackHandler[__menu_callback] = function(self, item)
			__BlockThisDiff[__diff] = tostring(item:value()) == "on" and true or false
			__Save()
		end
		MenuHelper:AddToggle({
			id = __menu_id,
			title = tweak_data.difficulty_name_ids[__diff],
			desc = ThisModMenuNoDesc,
			callback = __menu_callback,
			menu_id = ThisModMenuID,
			value = __BlockThisDiff[__diff] and true or false,
			priority = 100-__p
		})
		if type(__BlockThisDiff[__diff]) ~= "boolean" then
			__BlockThisDiff[__diff] = false
		end
		__menu_id = __Name("menu_id::"..__diff.."_one_down")
		__menu_callback = __Name("menu_callback::"..__diff.."_one_down")
		MenuCallbackHandler[__menu_callback] = function(self, item)
			__BlockThisDiff[__diff.."_one_down"] = tostring(item:value()) == "on" and true or false
			__Save()
		end
		MenuHelper:AddToggle({
			id = __menu_id,
			title = tweak_data.difficulty_name_ids[__diff].."_one_down",
			desc = ThisModMenuNoDesc,
			callback = __menu_callback,
			menu_id = ThisModMenuID,
			value = __BlockThisDiff[__diff.."_one_down"] and true or false,
			priority = 50-__p
		})
		if type(__BlockThisDiff[__diff.."_one_down"]) ~= "boolean" then
			__BlockThisDiff[__diff.."_one_down"] = false
		end
	end
	__Save()
end)

local function __IsJobOK(__data)
	if type(__data) == "table" and type(__BlockThisDiff) == "table" then
		if type(__data.difficulty_id) == "number" and tweak_data.difficulties[__data.difficulty_id] and __BlockThisDiff[tweak_data.difficulties[__data.difficulty_id]] then
			return false
		end
		if type(__data.one_down) == "number" and __data.one_down == 1 and type(__data.difficulty_id) == "number" and tweak_data.difficulties[__data.difficulty_id] and __BlockThisDiff[tweak_data.difficulties[__data.difficulty_id].."_one_down"] then
			return false
		end
	end
	return true
end

local Hook1 = __Name("add_preset_job")
local Hook2 = __Name("add_server_job")

CrimeNetGui[Hook1] = CrimeNetGui[Hook1] or CrimeNetGui.add_preset_job
CrimeNetGui[Hook2] = CrimeNetGui[Hook2] or CrimeNetGui.add_server_job

function CrimeNetGui:add_preset_job(preset_id, ...)
	local preset = managers.crimenet:preset(preset_id)
	if not __IsJobOK(preset) then
		return
	end
	self[Hook1](self, preset_id, ...)
end

function CrimeNetGui:add_server_job(data, ...)
	if not __IsJobOK(data) then
		return
	end
	self[Hook2](self, data, ...)
end

__Load()