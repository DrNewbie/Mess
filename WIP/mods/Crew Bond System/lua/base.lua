local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()

local __file = file
local __io = io

local __Name = function(__id)
	return "CW_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end

CrewBondUSystem = CrewBondUSystem or {}

if _G[__Name(100)] then return end
_G[__Name(100)] = true

CrewBondUSystem.__log = function(...)
	log( "[CrewBondUSystem]", json.encode({...}) )
	return
end

CrewBondUSystem.__criminal_number_table = CrewBondUSystem.__criminal_number_table or {}

CrewBondUSystem.__criminal_number_table[1] = nil

CrewBondUSystem.__bond_data_table = CrewBondUSystem.__bond_data_table or {}

CrewBondUSystem.__bond_number_map_table = CrewBondUSystem.__bond_number_map_table or {}

CrewBondUSystem.__is_bond_activing = CrewBondUSystem.__is_bond_activing or {}

CrewBondUSystem.__Name = __Name

pcall(function ()
	if not tweak_data.criminals then
		return
	end
	local number_table = {
		2,	--Dallas
		3,	--Wolf
		5,	--chains
		7,	--Houston
		11,	--John Wick
		13,	--Hoxton
		17,	--Clover
		19,	--Dragan
		23,	--Jacket
		29,	--Bonnie
		31,	--Sokol
		37,	--Jiro
		41,	--Bodhi
		43,	--Jimmy
		47,	--Sydney
		53,	--Rust
		59,	--Scarface
		61,	--Sangres
		67,	--Joy
		71,	--Duke
		73,	--Ethan
		79	--Hila
	}
	local chars = tweak_data.criminals.characters
	local this_table = {}
	for __i, character in pairs(chars) do
		this_table[character.name] = number_table[character.order]
		this_table[number_table[character.order]] = character.name
	end
	CrewBondUSystem.__criminal_number_table = this_table
	return
end)

CrewBondUSystem.__add_bond_number = function(__data)
	__data.criminals_name = __data.criminals_name or {}
	local this_criminals_number = __data.criminals_number
	local this_bond_number = 1
	local this_bond_number_map = {}
	local this_bond_function = function(...) 
		do end
		return
	end
	if type(__data.func) == "function" then
		this_bond_function = __data.func
	end
	for _, __number in pairs(this_criminals_number) do
		if type(__number) == "number" and __number > 1 then
			this_bond_number = this_bond_number * __number
			table.insert(this_bond_number_map, __number)
			local crew_name_id = "menu_"..CrewBondUSystem.__criminal_number_table[__number]
			local crew_name = managers.localization:text(crew_name_id)
			table.insert(__data.criminals_name, crew_name)
		end
	end

	if this_bond_number > 1 then
		this_bond_number = tostring(this_bond_number)
		CrewBondUSystem.__bond_data_table[this_bond_number] = CrewBondUSystem.__bond_data_table[this_bond_number] or {}
		CrewBondUSystem.__bond_data_table[this_bond_number][__Name(this_bond_function)] = __data
		
		CrewBondUSystem.__bond_number_map_table[this_bond_number] = CrewBondUSystem.__bond_number_map_table[this_bond_number] or {}
		CrewBondUSystem.__bond_number_map_table[this_bond_number] = this_bond_number_map
	end
	CrewBondUSystem.__log("__add_bond_number", this_bond_number)
	return this_bond_number
end

CrewBondUSystem.__announce_what_crew_bond_now = function(__data)
	DelayedCalls:Add(__Name(__data), 1,
		function()
			local __name_id = __data.name_id
			local __desc_id = __data.desc_id
			local __icon_id = __data.icon_id
			local __criminals_name = table.concat(__data.criminals_name or {}, " - ")
			if not __name_id then
				__name_id = "crewbond_bond_mod_empty_text"
			end
			if not __desc_id then
				__desc_id = "crewbond_bond_mod_empty_text"
			end
			HudCrewBondUSystemNotification.queue(
				managers.localization:text("crewbond_bond_mod_munu_name"),
				managers.localization:text(__name_id).."\n "..__criminals_name.."\n "..managers.localization:text(__desc_id),
				__icon_id
			)
			return
		end
	)
	return
end

CrewBondUSystem.__get_current_criminals_number = function(current_criminals)
	current_criminals = current_criminals or managers.groupai:state():all_char_criminals()
	local __criminals_number = 1
	local __criminals_number_map = {}
	if managers.criminals and type(current_criminals) == "table" and not table.empty(current_criminals) then
		for _, __data in pairs(current_criminals) do
			if __data.unit then
				local __name = tostring(managers.criminals:character_name_by_unit(__data.unit))
				local __char_name = CriminalsManager.convert_new_to_old_character_workname(__name)
				local __char_number = CrewBondUSystem.__criminal_number_table[__char_name]
				if type(__char_number) == "number" and __char_number > 1 then
					__criminals_number = __criminals_number * __char_number
					table.insert(__criminals_number_map, __char_number)
				end
			end
		end
	end
	return __criminals_number, __criminals_number_map
end

CrewBondUSystem.__on_bond_number_match = function(this_bond_number, ...)
	CrewBondUSystem.__log("__on_bond_number_match", this_bond_number)
	this_bond_number = tostring(this_bond_number)
	CrewBondUSystem.__bond_data_table[this_bond_number] = CrewBondUSystem.__bond_data_table[this_bond_number] or {}
	local this_bond_data_list = CrewBondUSystem.__bond_data_table[this_bond_number]
	for _, this_bond_data in pairs(this_bond_data_list) do
		if type(this_bond_data) == "table" and type(this_bond_data.func) == "function" then
			pcall(CrewBondUSystem.__announce_what_crew_bond_now, this_bond_data)
			pcall(this_bond_data.func, this_bond_number)
		end
	end
	return
end

CrewBondUSystem.__is_bond_activing = function(__bond_number)
	__bond_number = tostring(__bond_number)
	return CrewBondUSystem.__bond_activing[__bond_number] and true or false
end

CrewBondUSystem.__set_bond_activing = function(__bond_number, is_activing)
	__bond_number = tostring(__bond_number)
	CrewBondUSystem.__bond_activing[__bond_number] = is_activing
	if is_activing then
		CrewBondUSystem.__on_bond_number_match(__bond_number)
	end
	return
end

CrewBondUSystem.__clean_bond_activing = function()
	CrewBondUSystem.__bond_activing = {}
	return
end

CrewBondUSystem.__format_two_to_each_other = function(__criminals_number)
	local criminals_number_map_size = table.size(__criminals_number)
	local new_criminals_number_map = {}
	local already_insert = {}
	for __i = 1, criminals_number_map_size do
		for __d = 1, criminals_number_map_size do
			if __i ~= __d and not already_insert[__i*__d] then
				already_insert[__i*__d] = true
				table.insert(new_criminals_number_map, {__criminals_number[__i], __criminals_number[__d]})
			end
		end
	end
	return new_criminals_number_map
end

Hooks:Add("LocalizationManagerPostInit", __Name("LocalizationManagerPostInit"), function(self)
	local load_cfg = function()
		if not __file.DirectoryExists(ThisModPath.."/cfg/") then
			return
		end
		local __files = __file.GetFiles(ThisModPath.."/cfg/")
		if type(__files) ~= "table" or table.empty(__files) then
			return
		end
		for _, __cfg in pairs(__files) do
			local __cfg = ThisModPath.."/cfg/"..__cfg
			if __io.file_is_readable(__cfg) then
				DelayedCalls:Add(__Name(__cfg), 2, function()
					pcall(dofile, __cfg)
				end)
				CrewBondUSystem.__log("__load_bond_cfg", __cfg)
			end
		end
	end
	local load_loc = function(them)
		if not __file.DirectoryExists(ThisModPath.."/loc/") then
			return
		end
		local __files = __file.GetFiles(ThisModPath.."/loc/")
		if type(__files) ~= "table" or table.empty(__files) then
			return
		end
		for _, __loc in pairs(__files) do
			local __loc = ThisModPath.."/loc/"..__loc
			if __io.file_is_readable(__loc) then
				CrewBondUSystem.__log("__load_bond_loc", __loc)
				self:load_localization_file(__loc)
			end
		end
	end	
	pcall(load_cfg)
	pcall(load_loc)
end)