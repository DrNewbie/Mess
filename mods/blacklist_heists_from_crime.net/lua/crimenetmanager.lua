--https://discord.com/channels/242285927056015361/957411398168764436
local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local ThisModSave = SavePath .. "Blacklist-Heists-from-Crime-Net.json"
local __Name = function(__id)
	return "BHCN_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end
local ThisModMenuID = __Name("ThisModMenuID")
local ThisModMenuTitle = __Name("menu_title")
local ThisModMenuDesc = __Name("menu_desc")
local ThisModMenuNoDesc = __Name("menu_desc_empty")

local __BlockThisHeist = {["___"] = true}

local function __Save()
    local __file = io.open(ThisModSave, "w+")
    if __file then
        __file:write(json.encode(__BlockThisHeist))
        __file:close()
    end
	return
end

local function __Load()
	local __file = io.open(ThisModSave, "r")
	if __file then
		for __k, __v in pairs(json.decode(__file:read("*all")) or {}) do
			__BlockThisHeist[__k] = __v
		end
		__file:close()
	else
		__Save()
	end
	return
end

Hooks:Add("LocalizationManagerPostInit", __Name("LocalizationManagerPostInit"), function(loc)
	LocalizationManager:add_localized_strings({
		[ThisModMenuTitle] = "Blacklist Heists from Crime.Net",
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
	for _, __lvl in pairs(tweak_data.narrative._jobs_index) do
		if tweak_data.narrative.jobs[__lvl] and tweak_data.narrative.jobs[__lvl].name_id then
			local __menu_id = __Name("menu_id::"..__lvl)
			local __menu_callback = __Name("menu_callback::"..__lvl)
			MenuCallbackHandler[__menu_callback] = function(self, item)
				__BlockThisHeist[__lvl] = tostring(item:value()) == "on" and true or false
				__Save()
			end
			MenuHelper:AddToggle({
				id = __menu_id,
				title = tweak_data.narrative.jobs[__lvl].name_id,
				desc = ThisModMenuNoDesc,
				callback = __menu_callback,
				menu_id = ThisModMenuID,
				value = __BlockThisHeist[__lvl] and true or false
			})
			if type(__BlockThisHeist[__lvl]) ~= "boolean" then
				__BlockThisHeist[__lvl] = false
			end
		end
	end
	__Save()
end)

local function __IsJobOK(__data)
	if type(__data) == "table" and type(__BlockThisHeist) == "table" then
		if (type(__data.job_id) == "string" and __BlockThisHeist[__data.job_id]) or (type(__data.level_id) == "string" and __BlockThisHeist[__data.level_id]) then
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