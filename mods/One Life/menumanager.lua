Hooks:Add('MenuManagerOnOpenMenu', 'OneLifeGoodBye_RunFunc', function(self, menu)
	if (menu == 'menu_main' or menu == 'lobby') and Global.OneLifeGoodBye then
		DelayedCalls:Add('OneLifeGoodBye_RunNow', 1, function()
			Global.OneLifeGoodBye = false			
			--[[
				Bye!!
			]]
			MenuManager:do_clear_progress()			
			--[[
				Sell All Items by Offyerrocker ; http://modwork.shop/24537
			]]
			local bm = managers.blackmarket
			for _, category in pairs({"primaries","secondaries","masks"}) do
				for k, v in pairs(bm._global.crafted_items[category]) do
					if category == "masks" then 
						local mask = bm:get_crafted_category_slot("masks", k)
						local mask_id = mask.mask_id
						if (k ~= bm:equipped_mask_slot()) and (mask_id ~= "character_locked") then
							bm:on_sell_mask(k, true)
						end
					else
						local weapon = bm:get_crafted_category_slot(category, k)
						if weapon then
							if bm:equipped_weapon_slot(category) ~= k then 
								bm:on_sell_weapon(category, k, true)
							end
						end
					end
				end
			end
			--[[
				all skill tree reset by Mx ; http://modwork.shop/22718
			]]
			managers.skilltree:infamy_reset()			
			--[[
				OwO
			]]
			QuickMenu:new(
				"One Life",
				"This is your fresh new life ^_^",
				{{text = "ok", is_cancel_button = true}},
				true
			)			
			DelayedCalls:Add('OneLifeGoodBye_Refresh', 8, function()
				if not Global.game_settings or not Global.game_settings.difficulty then
					setup:load_start_menu()
				end
			end)
		end)
	end
end)