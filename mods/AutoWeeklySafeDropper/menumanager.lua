Hooks:Add('MenuManagerOnOpenMenu', 'WeeklySafeDrop_RunInitNow', function(self, menu)
	if (menu == 'menu_main' or menu == 'lobby') and managers.network and managers.network.account then
		if Global._WeeklySafeDropBool then
			return
		end
		Global._WeeklySafeDropBool = true
		DelayedCalls:Add('WeeklySafeDrop_RunInitNow_Delay', 1, function()
			_G.WeeklySafeDrop = _G.WeeklySafeDrop or {}	
			function WeeklySafeDrop:Ask()
				if managers.network.account:inventory_reward(callback(WeeklySafeDrop, WeeklySafeDrop, "Result")) then
					--True
				else
					--False
				end
			end
			function WeeklySafeDrop:Result()
				--Why?
			end
			WeeklySafeDrop:Ask()
		end)
	end
end)