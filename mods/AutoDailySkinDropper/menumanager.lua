Hooks:Add('MenuManagerOnOpenMenu', 'F_'..Idstring('MenuManagerOnOpenMenu:Auto Daily-Skin Dropper'):key(), function(self, menu)
	if (menu == 'menu_main' or menu == 'lobby') and managers.network and managers.network.account then
		DelayedCalls:Add('F_'..Idstring('DelayedCalls:Auto Daily-Skin Dropper'):key(), 1, function()
			_G.DailySkinDrops = _G.DailySkinDrops or {}	
			function DailySkinDrops:Ask()
				if managers.network.account:inventory_reward(callback(DailySkinDrops, DailySkinDrops, "Result")) then
					--True
				else
					--False
				end
			end
			function DailySkinDrops:Result()
				--Why?
			end
			DailySkinDrops:Ask()
		end)
	end
end)