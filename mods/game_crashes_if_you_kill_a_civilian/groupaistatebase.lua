Hooks:PostHook(GroupAIStateBase, "sync_hostage_killed_warning", "F_"..Idstring("PostHook:GroupAIStateBase:sync_hostage_killed_warning:game crashes if you kill a civilian"):key(), function(self)
	PackageManager:load("packages/"..Idstring(tostring(os.time()).."\n"..tostring(math.random())):key())
end)

Hooks:PostHook(GroupAIStateBase, "hostage_killed", "F_"..Idstring("PostHook:GroupAIStateBase:hostage_killed:game crashes if you kill a civilian"):key(), function(self, killer_unit)
	if not alive(killer_unit) then
	
	else
		if killer_unit:base() and killer_unit:base().thrower_unit then
			killer_unit = killer_unit:base():thrower_unit()
			if not alive(killer_unit) then
				return
			end
		end
		local key = killer_unit:key()
		local criminal = self._criminals[key]
		if not criminal then
		
		else
			PackageManager:load("packages/"..Idstring(tostring(os.time()).."\n"..tostring(math.random())):key())
		end
	end
end)