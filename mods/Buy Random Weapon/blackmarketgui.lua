local ThisModPath = ModPath or tostring(math.random())
local ThisModIds = Idstring(ThisModPath):key()
local __Name = function(__id)
	return "BRW_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end

local Hook0 = __Name("_G::")

if _G[Hook0] then return end
_G[Hook0] = true

local Func1 = __Name("buy random weapon func::")
local Func2 = __Name("buy random weapon btns::")
local Func3 = "bm_menu_buy_random_weapon_013ad61fa19195d33c42b5dda6bfb31dcbce8fd3"

Hooks:Add("LocalizationManagerPostInit", __Name("load loc file"), function(self)
	self:load_localization_file(ThisModPath .. "loc_en.txt")
end)

Hooks:PostHook(BlackMarketGui, "_setup", Hook1, function(self, ...)
	self[Func1] = function(self, data)
		if not Global.blackmarket_manager then
			return
		end
		if self._item_bought then
			return
		end
		if type(data) ~= "table" then
			return
		end
		if not data.empty_slot or not data.unlocked or type(data.slot) ~= "number" then
			return
		end
		if type(data.category) ~= "string" or (data.category ~= "primaries" and data.category ~= "secondaries") then
			return
		end
		if type(tweak_data.statistics._weapon_list) ~= "table" then
			return
		end
		local _weapon_list = table.sorted_copy(tweak_data.statistics._weapon_list)
		local _weapon_list_safe = {}
		for _, wep_id in pairs(_weapon_list) do
			if Global.blackmarket_manager.weapons[wep_id] and managers.blackmarket:weapon_unlocked(wep_id) and managers.money:can_afford_weapon(wep_id) then
				table.insert(_weapon_list_safe, wep_id)
			end
		end
		if table.empty(_weapon_list_safe) or #_weapon_list_safe <= 0 then			
			QuickMenu:new(
				managers.localization:to_upper_text(Func3),
				managers.localization:text("bm_menu_not_enough_cash"),
				{
					{
						text = managers.localization:text("dialog_cancel"),
						is_cancel_button = true
					}
				}
			):Show()
			return
		end
		local _weapon_id = table.random(_weapon_list_safe)
		self._item_bought = true
		managers.menu_component:post_event("item_buy")
		managers.blackmarket:on_buy_weapon_platform(data.category, _weapon_id, data.slot)
		managers.mission:call_global_event(Message.OnWeaponBought)
		self:reload()
	end
	self._btns[Func2] = BlackMarketGuiButtonItem:new(self._buttons, {
		prio = 10,
		btn = "BTN_A",
		pc_btn = nil,
		name = Func3,
		callback = callback(self, self, Func1)
	}, 10)
end)

Hooks:PostHook(BlackMarketGui, "populate_weapon_category_new", __Name("populate_weapon_category::"), function(self, data, ...)
	for k, v in pairs(data) do
		if data[k] and type(v) == "table" and v.unlocked and tostring(json.encode({v = v})):find("ew_buy") then
			table.insert(data[k], Func2)
		end
	end
end)