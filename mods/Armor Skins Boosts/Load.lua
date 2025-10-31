function Load_ArmorSkinsBoosts()
	if tweak_data and tweak_data.economy and tweak_data.economy.armor_skins then
		local _DATA_PATH = "mods/Armor Skins Boosts/data/"
		local _files = file.GetFiles(_DATA_PATH) or {}
		for _, _file_name in pairs(_files) do
			local _file = io.open(_DATA_PATH .. _file_name, "r")
			local _data = {}
			if _file then
				_data = json.decode(_file:read("*all"))
				_file:close()
				tweak_data.economy.armor_skins[_file_name] = tweak_data.economy.armor_skins[_file_name] or {}
				tweak_data.economy.armor_skins[_file_name].body_armor = tweak_data.economy.armor_skins[_file_name].body_armor or {}
				tweak_data.economy.armor_skins[_file_name].body_armor = _data
			end
		end		
	end
end


function Get_Current_ArmorSkinsBoosts(cat)
	local equipped_armor = managers.blackmarket:equipped_armor() or "level_1"
	local armor_skins_data = tweak_data.economy.armor_skins[tostring(managers.blackmarket:equipped_armor_skin())] or {}
	local ADD_NUM = 0
	if armor_skins_data and armor_skins_data.body_armor and armor_skins_data.body_armor[cat] then
		ADD_NUM = armor_skins_data.body_armor[cat][equipped_armor] or 0
	end
	return ADD_NUM
end

Load_ArmorSkinsBoosts()