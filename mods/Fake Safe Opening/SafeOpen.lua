Hooks:Add('MenuManagerOnOpenMenu', 'RandomFakeSafeOpen_RunInitNow', function(self, menu)
	if menu == 'menu_main' or menu == 'lobby' then
		if not Global._RandomFakeSafeOpenBool then
			Global._RandomFakeSafeOpenBool = 5
		end
		if Global._RandomFakeSafeOpenBool > 0 then
		
		else
			return
		end
		math.randomseed(tostring(os.time()):reverse():sub(1, 6))
		DelayedCalls:Add('RandomFakeSafeOpen_RunInitNow_Delay', 3, function()
			if not tweak_data.economy then
				return
			end
			Global._RandomFakeSafeOpenBool = Global._RandomFakeSafeOpenBool - 1
			local choose_item = function(safe)
				local data = {amount = 1, category = safe._type}
				data.bonus = math.random(100) > 10
				local weap_index = tweak_data.economy.contents[safe.content].contains[safe._type]
				data.entry = table.random(weap_index)
				data.quality = table.random({"poor", "fair", "good", "fine", "mint"})
				data.def_id = 101
				local i = 1
				while managers.blackmarket._global.inventory_tradable[tostring(i)] ~= nil do
					i = i + 1
				end
				data.instance_id = tostring(i)
				return data
			end
			local safe_entry = table.random_key(tweak_data.economy.safes)
			local safe_tweak = tweak_data.economy.safes[safe_entry]
			local safe_retry = 50
			while safe_retry > 0 do
				safe_retry = safe_retry - 1
				if safe_tweak and safe_tweak.content then
					local content = tweak_data.economy.contents[safe_tweak.content]
					if content.contains then
						if content.contains.weapon_skins then
							safe_tweak._type = "weapon_skins"
						elseif content.contains.weapon_skins then
							--safe_tweak._type = "armor_skins"
						end
					end
				end
				if safe_tweak._type then
					local function ready_clbk()
						managers.menu:back()
						managers.system_menu:force_close_all()
						managers.menu_component:set_blackmarket_enabled(false)
						managers.menu:open_node("open_steam_safe", {safe_tweak.content})
					end
					managers.menu_component:set_blackmarket_disable_fetching(true)
					managers.menu_component:set_blackmarket_enabled(false)
					managers.menu_scene:create_economy_safe_scene(safe_entry, ready_clbk)
					local item = choose_item(safe_tweak)
					MenuCallbackHandler:_safe_result_recieved(nil, {item}, {})
					if false then
						managers.blackmarket:tradable_add_item(item.instance_id, "weapon_skins", item.entry, item.quality, item.bonus, 1)
					end
					break
				end
				safe_entry = table.random_key(tweak_data.economy.safes)
				safe_tweak = tweak_data.economy.safes[safe_entry]
			end
		end)
	end
end)