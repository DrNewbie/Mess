local ThisModPath = ModPath or tostring(math.random())
local ThisModIds = Idstring(ThisModPath):key()
local __Name = function(__id)
	return "BRW_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end

local Hook0 = __Name("_G::")

if _G[Hook0] then return end
_G[Hook0] = true

local Hook2 = __Name("populate_weapon_category::")
local Hook3 = __Name("LocalizationManagerPostInit::")
local Func1 = __Name("buy random weapon func::")
local Func2 = __Name("buy random weapon btns::")
local Func3 = __Name("buy random weapon name::")

Hooks:Add("LocalizationManagerPostInit", Hook3, function()
	LocalizationManager:add_localized_strings({
		[Func3] = "Buy Random Weapon"
	})
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
		if type(data.category) ~= "string" or (data.category ~= "primaries" and data.category ~= "secondary") then
			return
		end
		local _weapon_list = tweak_data.statistics._weapon_list
		if type(_weapon_list) ~= "table" then
			return
		end
		local _weapon_list_safe = {}
		for id, wep_id in pairs(_weapon_list) do
			if Global.blackmarket_manager.weapons[wep_id] and managers.blackmarket:weapon_unlocked(wep_id) then
				table.insert(_weapon_list_safe, wep_id)
			end
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

Hooks:PostHook(BlackMarketGui, "populate_weapon_category_new", Hook2, function(self, data, ...)
	for k, v in pairs(data) do
		if data[k] and type(v) == "table" and v.unlocked and tostring(json.encode({v = v})):find("ew_buy") then
			table.insert(data[k], Func2)
		end
	end
end)