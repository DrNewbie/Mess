local ThisModIds = Idstring(tostring(ModPath)):key()

local __Name = function(__id)
	return "T_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end

Hooks:Add("MenuManagerOnOpenMenu", __Name("hook this function"), function(__them, __menu)
	if type(__menu) == "string" and (__menu == "menu_main" or __menu == "lobby") and type(Distribution) == "userdata" then
		DelayedCalls:Add(__Name("delay run"), 1, function()
			pcall(function()
				if IS_STEAM then
					Distribution:inventory():reward_item_drop(1, function() log("[AutoDailySkinDropper] Run.") end)
				end
			end)
		end)
	end
end)