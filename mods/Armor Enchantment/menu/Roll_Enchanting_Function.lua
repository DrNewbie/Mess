_G.EEArmorBuff = _G.EEArmorBuff or {0, 0, 0, 0, 0}

local function __apply(__data) return managers.player:__EE_Armor_Apply(__data) end
local function __save(__data) return managers.player:__EE_Armor_Save(__data) end
local function __load() return managers.player:__EE_Armor_Load() end
local function __type_list() return managers.player:__EE_Armor_Bonus_Type_List() end
local function __p_amount() return managers.player:__EE_Armor_Possible_Amount() end
local function __bonus_list() return managers.player:__EE_Armor_Bonus_List() end
local function __bonus_var(ee_i, lv) return managers.player:__EE_Armor_Bonus_Value(ee_i, lv) end
local function __loc_text(__data) return managers.localization:text(__data) end

local function __rnd_table_by_amount(__t)
	math.randomseed()
	math.randomseed()
	math.randomseed()
	math.random()
	math.random()
	math.random()
	local new_t = {}
	for __i, __d in pairs(__t) do
		for __idx = 1, __d do
			table.insert(new_t, __i)
		end
	end
	table.shuffle(new_t)
	return table.random(new_t)
end

local function __data2desc(data, no_name)
	if type(data) ~= "table" or type(data[1]) ~= "number" or type(data[2]) ~= "number" or not __type_list()[data[1]] then
		return " "
	end
	local __EE_Armor_name = __loc_text("ee_armor_p_"..__type_list()[data[1]].."_name_id")
	local __EE_Armor_desc = __loc_text("ee_armor_p_"..__type_list()[data[1]].."_desc_id")
	__EE_Armor_desc = __EE_Armor_desc:gsub("%$%$var%$%$", data[2])
	return (no_name and "" or "[ "..__EE_Armor_name.." ] ")..__EE_Armor_desc
end

function BlackMarketGui:__set_eenchanting_armor_date_to_text(onoff)
	local slot_data = self._slot_data
	if not type(slot_data) == "table" or not slot_data["name"] then
		log("[EE_A]: __set_eenchanting_armor_date_to_text, 1")
		return
	end
	if self._stats_panel and self._stats_panel:child("addon_armor_desc") then
		local addon_armor_desc = self._stats_panel:child("addon_armor_desc")
		if onoff then
			addon_armor_desc:set_visible(true)
			local ee_d = __load()[slot_data["name"]]
			local ee_s = {}
			local ee_text = {}
			if type(ee_d) == "table" and type(ee_d[1]) == "table" then
				local __EE_Armor_text = ""
				for i = 1, #ee_d do
					__EE_Armor_text = "[+] "..__data2desc({ee_d[i][1], ee_d[i][2]}, true).." \n" .. __EE_Armor_text
					ee_s[ee_d[i][1]] = true
				end
				for __i, __d in pairs(ee_s) do
					if __d then
						table.insert(ee_text, __loc_text("ee_armor_p_shorten_"..__type_list()[__i]))
					end
				end
				__EE_Armor_text = "[ "..table.concat(ee_text, "-").." ]\n"..__EE_Armor_text
				addon_armor_desc:set_text(__EE_Armor_text)
			else
				addon_armor_desc:set_visible(false)
			end
		else
			addon_armor_desc:set_visible(false)
		end
	end
	return
end

function BlackMarketGui:__roll_eenchanting_armor_function(data)
	local slot_data = self._slot_data
	if not type(slot_data) == "table" or not slot_data["name"] then
		log("[EE_A]: __roll_eenchanting_armor_function, 1")
		return
	end
	local __possible_ee_amount = __p_amount()
	__possible_ee_amount = __rnd_table_by_amount(__possible_ee_amount)
	local __EE_Armor_gain = {
	
	}
	local __EE_Armor_text = ""
	for i = 1, __possible_ee_amount do
		local __EE_Armor_pick = __rnd_table_by_amount(__bonus_list())
		if __type_list()[__EE_Armor_pick] then
			local __var1 = __bonus_var(__EE_Armor_pick) or 0
			if __var1 > 0 or __var1 < 0 then
				table.insert(__EE_Armor_gain, {[1] = __EE_Armor_pick, [2] = __var1})			
				__EE_Armor_text = __data2desc({__EE_Armor_pick, __EE_Armor_gain[#__EE_Armor_gain][2]}).." \n" .. __EE_Armor_text
			end
		end
	end
	managers.system_menu:show({
		title = "["..__loc_text("bm_menu_enchant_armor_name_id").."]",
		text = __EE_Armor_text,
		button_list = {
			{text = "[Cancel]", is_cancel_button = true}
		},
		id = tostring(math.random(0,0xFFFFFFFF))
	})
	local ee_d = __load()
	ee_d[slot_data["name"]] = __EE_Armor_gain
	__save(ee_d)
	self:equip_armor_callback({name = slot_data["name"]})
	self:__set_eenchanting_armor_date_to_text(true)
end