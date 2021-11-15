local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local Hook1 = "F_"..Idstring("Hook1::"..ThisModIds):key()
local Func1 = "F_"..Idstring("Func1::"..ThisModIds):key()

BlackMarketGui[Func1] = BlackMarketGui[Func1] or function(self, data)
	if data.data and type(data.data.cc_cost) == "number" and data.MB_Confirm and type(data.MB_Times) == "number" then
		local NEW_data = data.data
		local params = {}
		local cost_coins = NEW_data.cc_cost
		params.name = NEW_data.name_localized or NEW_data.name
		local success = 0
		for i = 1, data.MB_Times do
			if managers.custom_safehouse:coins() >= cost_coins then			
				managers.menu_component:post_event("item_sell")
				managers.blackmarket:add_to_inventory(NEW_data.global_value, "weapon_mods", NEW_data.name, true)
				managers.custom_safehouse:deduct_coins(cost_coins)
				self:reload()
				success = success + 1
			end
		end
		managers.system_menu:show({
			title = "[Multi-Buy]",
			text = "Successfully Purchase: " .. success .. " (Cost: ".. managers.experience:cash_string(cost_coins*success, "") ..")",
			button_list = {
				{ text = "[Cancel]", is_cancel_button = true }
			},
			id = tostring(math.random(0,0xFFFFFFFF))
		})	
	end
end

Hooks:PostHook(BlackMarketGui, "_confirm_purchase_weapon_mod_callback", Hook1, function(self, data)
	if type(data) == "table" and type(data.cc_cost) == "number" then
		local coins = managers.custom_safehouse:coins()
		if type(coins) == "number" and coins >= data.cc_cost then
			local cost_coins = data.cc_cost
			managers.system_menu:show({
				title = "[Multi-Buy]",
				text = "Choose what you want.",
				button_list = {
					{ text = "x1 (Cost: ".. managers.experience:cash_string(cost_coins, "") ..")", callback_func = callback(self, self, Func1, {data = data, MB_Confirm = true, MB_Times = 1}) },
					{ text = "x10 (Cost: ".. managers.experience:cash_string(cost_coins*10, "") ..")", callback_func = callback(self, self, Func1, {data = data, MB_Confirm = true, MB_Times = 10}) },
					{ text = "x100 (Cost: ".. managers.experience:cash_string(cost_coins*100, "") ..")", callback_func = callback(self, self, Func1, {data = data, MB_Confirm = true, MB_Times = 100}) },
					{ text = "[Cancel]", is_cancel_button = true }
				},
				id = tostring(math.random(0,0xFFFFFFFF))
			})
		end
	end
end)