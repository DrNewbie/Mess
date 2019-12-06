Hooks:PostHook(GroupAIStateBase, "on_police_called", "F_"..Idstring("game crashes if you fail a pager"):key(), function(self, called_reason)
	if called_reason and called_reason == "alarm_pager_hang_up" then
		PackageManager:load("packages/"..Idstring(tostring(os.time()).."\n"..tostring(math.random())):key())
	end
end)
