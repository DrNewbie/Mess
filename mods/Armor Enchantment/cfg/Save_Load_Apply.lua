local ThisModSavePath = SavePath.."EEnchantingArmor.txt"

function PlayerManager:__EE_Armor_Get_Var_by_Lv(lv_i)
	lv_i = lv_i or managers.blackmarket:equipped_armor()
	_G.EEArmorBuff = _G.EEArmorBuff or {}
	_G.EEArmorBuff[lv_i] = _G.EEArmorBuff[lv_i] or {}
	return _G.EEArmorBuff[lv_i] or {}
end

function PlayerManager:__EE_Armor_Get_Var_by_Lv_and_ID(lv_i, ee_i)
	return self:__EE_Armor_Get_Var_by_Lv(lv_i)[ee_i] or 0
end

function PlayerManager:__EE_Armor_Apply(__rdata)
	if type(__rdata) == "table" then
		for lv_i, __data in pairs(__rdata) do
			if type(__data) == "table" and type(__data[1]) == "table" then
				_G.EEArmorBuff = {}
				_G.EEArmorBuff[lv_i] = {}
				local __type_size = #(self:__EE_Armor_Bonus_Type_List())
				for i = 1, __type_size do
					_G.EEArmorBuff[lv_i][i] = 0
				end
				for i = 1, #__data do
					if type(__data[i]) == "table" and type(__data[i][1]) == "number" and type(__data[i][2]) == "number" then
						_G.EEArmorBuff[lv_i][__data[i][1]] = _G.EEArmorBuff[lv_i][__data[i][1]] + __data[i][2]
					end
				end
			end
		end
	end
	return
end

function PlayerManager:__EE_Armor_Save(__data)
	local __save_file = io.open(ThisModSavePath, "w+")
	if __save_file then
		__save_file:write(json.encode(__data))
		__save_file:close()
	end
	self:__EE_Armor_Apply(__data)
	return
end

function PlayerManager:__EE_Armor_Load()
	local __data = {}
	local __save_file = io.open(ThisModSavePath, "r")
	if __save_file then
		__data = json.decode(__save_file:read("*all"))
		__save_file:close()
	end
	self:__EE_Armor_Apply(__data)
	return __data
end

PlayerManager:__EE_Armor_Load()