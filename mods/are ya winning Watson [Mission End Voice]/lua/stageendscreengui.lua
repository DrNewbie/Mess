local mod_ids = Idstring("are ya winning Watson [Mission End Voice]"):key()
local func1 = "F_"..Idstring("func1::"..mod_ids):key()
local func2 = 3

Hooks:PostHook(StageEndScreenGui, "update", func1, function(self, t, dt)
	if func2 > 0 then
		func2 = func2 - dt
	elseif func2 < 0 then
		func2 = 0
		managers.menu_component:post_event("ogg_5ff9c170d1ec417a")
	end
end)