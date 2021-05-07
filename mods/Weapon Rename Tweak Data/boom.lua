_G.GGWEPNENAME = _G.GGWEPNENAME or {}
GGWEPNENAME.ModPath = GGWEPNENAME.ModPath or ModPath
GGWEPNENAME.Configs = GGWEPNENAME.Configs or {}

local mod_ids = Idstring("Weapon Rename"):key()
local func1 = "F_"..Idstring("func1::"..mod_ids):key()
local func2 = "F_"..Idstring("func2::"..mod_ids):key()
local func3 = "F_"..Idstring("func3::"..mod_ids):key()
local func4 = "F_"..Idstring("func4::"..mod_ids):key()
local bool1 = "F_"..Idstring("bool1::"..mod_ids):key()

function GGWEPNENAME:Add(id, func)
	if not func then
		return
	end
	if not id then
		id = "G_"..Idstring("GGWEPNENAME_"..tostring(func)):key()
	end
	GGWEPNENAME.Configs[id] = func
end

function GGWEPNENAME:Init()
	local configs = file.GetFiles(self.ModPath.."/configs/")
	for i, cfg in pairs(configs) do
		dofile(self.ModPath.."/configs/"..cfg)
	end
end

function GGWEPNENAME:GetNewNameFromWeaponMods(data)
	data[bool1] = false
	local try_name = data.name_localized
	local G_BMC = Global.blackmarket_manager.crafted_items
	if type(G_BMC) == "table" and type(data) == "table" then
		if (data.category == "primaries" or data.secondary == "secondaries") and type(G_BMC[data.category]) == "table" and type(G_BMC[data.category][data.slot]) == "table" then
			local W_data = G_BMC[data.category][data.slot]
			if type(W_data.blueprint) == "table" then
				for _, func in pairs(GGWEPNENAME.Configs) do
					try_name = func(data, tostring(W_data.factory_id), W_data.blueprint, W_data)
				end
				for i, part_id in pairs(W_data.blueprint) do
					if tweak_data.weapon.factory.parts[part_id] and tweak_data.weapon.factory.parts[part_id].weapon_rename_overwrite then
						try_name = tweak_data.weapon.factory.parts[part_id].weapon_rename_overwrite
					end
				end
			end
		end
	end
	if tostring(data.name_localized) ~= tostring(try_name) then
		data[bool1] = true
	end
	data.name_localized = try_name
	return data
end

if BlackMarketGui and string.lower(RequiredScript) == "lib/managers/menu/blackmarketgui" then
	BlackMarketGui[func4] = function(self, data)
		data = GGWEPNENAME:GetNewNameFromWeaponMods(data)
		if self._title_text then
			local new_tile = managers.localization:to_upper_text("bm_menu_blackmarket_title", {item = data.name_localized})
			self._title_text:set_text(new_tile)
			self:make_fine_text(self._title_text)
		end
		return data
	end

	Hooks:PostHook(BlackMarketGui, "populate_weapon_category_new", func1, function(self, data)
		local max_items = self:calc_max_items(#data, data.override_slots)
		for i = 1, max_items do
			data[i] = GGWEPNENAME:GetNewNameFromWeaponMods(data[i])
		end
	end)

	Hooks:PostHook(BlackMarketGui, "_buy_mod_callback", func2, function(self, data)
		data = self[func4](self, data)
	end)

	Hooks:PostHook(BlackMarketGui, "_remove_mod_callback", func3, function(self, data)
		data = self[func4](self, data)
	end)
end

if BlackMarketManager and string.lower(RequiredScript) == "lib/managers/blackmarketmanager" then
	local oldf1 = BlackMarketManager.get_weapon_name_by_category_slot
	function BlackMarketManager:get_weapon_name_by_category_slot(category, slot, ...)
		local ans = oldf1(self, category, slot, ...)
		data = GGWEPNENAME:GetNewNameFromWeaponMods({category = category, slot = slot})
		if data[bool1] then
			ans = data.name_localized
		end
		return ans
	end
end

GGWEPNENAME:Init()