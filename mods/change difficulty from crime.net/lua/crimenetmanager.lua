local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local ThisModSave = SavePath .. "Change-Difficulty-from-Crime-Net.json"
local __Name = function(__id)
	return "CDCN_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end
local ThisModMenuID = __Name("ThisModMenuID")
local ThisModMenuTitle = __Name("menu_title")
local ThisModMenuDesc = __Name("menu_desc")
local ThisModMenuNoDesc = __Name("menu_desc_empty")

local __ChangeThisDiff = {
	["___"] = true,
	["normal"] = 1,
	["hard"] = 2,
	["overkill"] = 3,
	["overkill_145"] = 4,
	["easy_wish"] = 5,
	["overkill_290"] = 6,
	["sm_wish"] = 7,
}

local ThisModDiffList = {
	"normal",
	"hard",
	"overkill",
	"overkill_145",
	"easy_wish",
	"overkill_290",
	"sm_wish"
}

local function __Save()
    local __file = io.open(ThisModSave, "w+")
    if __file then
        __file:write(json.encode(__ChangeThisDiff))
        __file:close()
    end
	return
end

local function __Load()
	local __file = io.open(ThisModSave, "r")
	if __file then
		for __k, __v in pairs(json.decode(__file:read("*all")) or {}) do
			__ChangeThisDiff[__k] = __v
		end
		__file:close()
	else
		__Save()
	end
	return
end

Hooks:Add("LocalizationManagerPostInit", __Name("LocalizationManagerPostInit"), function(...)
	LocalizationManager:add_localized_strings({
		[ThisModMenuTitle] = "Change Difficulty from Crime.Net",
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
	local opts = {
		tweak_data.difficulty_name_ids.normal,
		tweak_data.difficulty_name_ids.hard,
		tweak_data.difficulty_name_ids.overkill,
		tweak_data.difficulty_name_ids.overkill_145,
		tweak_data.difficulty_name_ids.easy_wish,
		tweak_data.difficulty_name_ids.overkill_290,
		tweak_data.difficulty_name_ids.sm_wish,
		tweak_data.difficulty_name_ids.normal.."_one_down",
		tweak_data.difficulty_name_ids.hard.."_one_down",
		tweak_data.difficulty_name_ids.overkill.."_one_down",
		tweak_data.difficulty_name_ids.overkill_145.."_one_down",
		tweak_data.difficulty_name_ids.easy_wish.."_one_down",
		tweak_data.difficulty_name_ids.overkill_290.."_one_down",
		tweak_data.difficulty_name_ids.sm_wish.."_one_down"
	}
	--Give OD name
	for __p, __diff in pairs(ThisModDiffList) do
		local diff_name_id = tweak_data.difficulty_name_ids[__diff]
		if diff_name_id then
			local od_diff_name_id = diff_name_id.."_one_down"
			LocalizationManager:add_localized_strings({
				[od_diff_name_id] = managers.localization:text(diff_name_id)..", "..managers.localization:text("menu_one_down")
			})
		end
	end
	--Create Opts
	for __p, __diff in pairs(ThisModDiffList) do
		local __menu_id = __Name("menu_id::"..__diff)
		local __menu_callback = __Name("menu_callback::"..__diff)
		MenuCallbackHandler[__menu_callback] = function(self, item)
			__ChangeThisDiff[__diff] = tonumber(item:value())
			__Save()
		end
		MenuHelper:AddMultipleChoice({
			id = __menu_id,
			title = tweak_data.difficulty_name_ids[__diff],
			desc = ThisModMenuNoDesc,
			callback = __menu_callback,
			items = opts,
			value = __ChangeThisDiff[__diff] and __ChangeThisDiff[__diff] or __p,
			menu_id = ThisModMenuID,
			priority = 100-__p,
		})
		if type(__ChangeThisDiff[__diff]) ~= "number" or __ChangeThisDiff[__diff] <= 0 or __ChangeThisDiff[__diff] > #opts then
			__ChangeThisDiff[__diff] = __p
		end
	end
	__Save()
end)

local function __IsJobOK(__data)
	if type(__data) == "table" and type(__ChangeThisDiff) == "table" and not __data.host_id and not __data.room_id  then
		if type(__data.difficulty_id) == "number" and tweak_data.difficulties[__data.difficulty_id] then
			local __diff = tweak_data.difficulties[__data.difficulty_id]
			if type(__ChangeThisDiff[__diff]) == "number" and __ChangeThisDiff[__diff] > 0 then
				local new_diff = __ChangeThisDiff[__diff] + 1
				if new_diff > 8 then
					__data.difficulty_id = new_diff - 7
					__data.one_down = 1
				else
					__data.difficulty_id = new_diff
				end
				__data.difficulty = tweak_data:index_to_difficulty(__data.difficulty_id)
			end
		end
	end
	return __data
end

local Hook1 = __Name("add_preset_job")

CrimeNetGui[Hook1] = CrimeNetGui[Hook1] or CrimeNetGui.add_preset_job

function CrimeNetGui:add_preset_job(preset_id, ...)
	local preset = managers.crimenet:preset(preset_id)
	preset = __IsJobOK(preset)
	managers.crimenet._presets[preset_id] = preset
	self[Hook1](self, preset_id, ...)
end

__Load()