local ThisModPath = ModPath or tostring(math.random())
local ThisModIds = Idstring(ThisModPath):key()
local __Name = function(__id)
	return "WMD_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end
local ThisModSavePath = SavePath.."Write Inventory Description Save File__"..__Name(ThisModIds)..".txt"

local function __Save(__data)
	local __save_file = io.open(ThisModSavePath, "w+")
	if __save_file then
		__save_file:write(json.encode(__data))
		__save_file:close()
	end
	return
end

local function __Load()
	local __data = {}
	local __save_file = io.open(ThisModSavePath, "r")
	if __save_file then
		__data = json.decode(__save_file:read("*all"))
		__save_file:close()
	else
		__Save({"none"})
	end
	return __data
end

local InventoryDescriptionData = __Load()

local function __Apply(them)
	if type(them._slot_data) == "table" and type(them._info_texts) == "table" and type(them._info_texts[4]) == "userdata" then
		local craft = Global.blackmarket_manager.crafted_items
		local slot = them._slot_data.slot
		local cat = them._slot_data.category
		local key = __Name(json.encode({cat, slot}))
		if craft[cat] and craft[cat][slot] and type(InventoryDescriptionData[key]) == "string" then
			them:set_info_text(4, InventoryDescriptionData[key], Color.white)
		end
	end
	return them
end

Hooks:PostHook(BlackMarketGui, "mouse_pressed", __Name("mouse_pressed"), function(self, __button, __x, __y)
	if QuickKeyboardInput and type(self._info_texts[4]) == "userdata" and tostring(__button) == tostring(Idstring("0")) and self._info_texts[4] and alive(self._info_texts[4]) then
		if type(self._slot_data) == "table" and self._info_texts[4]:inside(__x, __y) then
			local craft = Global.blackmarket_manager.crafted_items
			local slot = self._slot_data.slot
			local cat = self._slot_data.category
			local key = __Name(json.encode({cat, slot}))
			if craft[cat] and craft[cat][slot] then
				function __qki_callback_ok(__text)
					InventoryDescriptionData[key] = __text
					__Save(InventoryDescriptionData)
					self = __Apply(self)
				end
				local __Inventory_id, __Inventory_data
				if cat == "masks" and craft[cat][slot].mask_id then 
					__Inventory_id = craft[cat][slot].mask_id
					__Inventory_data = tweak_data.blackmarket.masks[__Inventory_id]
				elseif (cat == "primaries" or cat == "secondaries") and craft[cat][slot].weapon_id then 
					__Inventory_id = craft[cat][slot].weapon_id
					__Inventory_data = tweak_data.weapon[__Inventory_id]				
				end
				if __Inventory_data and __Inventory_data.name_id then
					local __Inventory_name = managers.localization:text(__Inventory_data.name_id)
					local __title = "[ "..tostring(__Inventory_name).." ]"
					local __message = "Change this item description to..."
					local __params = {
						default_value = ' ',
						changed_callback = __qki_callback_ok
					}
					local __show_immediately = true
					QuickKeyboardInput:new(__title, __message, __params, __show_immediately)
				end
			end
		end
	end
end)

Hooks:PostHook(BlackMarketGui, "update_info_text", __Name("p3"), function(self)
	self = __Apply(self)
end)

Hooks:PostHook(BlackMarketGui, "_setup", __Name("p4"), function(self)
	for weapon_id, _ in pairs(tweak_data.weapon) do
		if type(tweak_data.weapon[weapon_id]) == "table" and tweak_data.weapon[weapon_id].desc_id then
			tweak_data.weapon[weapon_id].has_description = true
		end
	end
	self = __Apply(self)
end)