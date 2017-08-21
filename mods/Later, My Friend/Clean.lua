_G.LaterMyFriendMenu = _G.LaterMyFriendMenu or {}

if LaterMyFriendMenu then
	DelayedCalls:Add("LaterMyFriendMenuClean", 5, function()
		if not Utils:IsInHeist() then
			LaterMyFriendMenu._data = LaterMyFriendMenu._data or {}
			LaterMyFriendMenu._data._users = {0}
			LaterMyFriendMenu:Save()
		end
	end)
end