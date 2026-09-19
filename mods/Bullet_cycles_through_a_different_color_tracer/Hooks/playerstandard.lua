Hooks:PostHook(PlayerStandard, "init", "F_"..Idstring("PostHook:PlayerStandard:init:Bullet cycles through a different color tracer"):key(), function(self)
	local ids_loads = {
		Idstring("effects/payday2/particles/weapons/streaks/blue_long_streak"),
		Idstring("effects/payday2/particles/weapons/streaks/cyan_long_streak"),
		Idstring("effects/payday2/particles/weapons/streaks/green_long_streak"),
		Idstring("effects/payday2/particles/weapons/streaks/magenta_long_streak"),
		Idstring("effects/payday2/particles/weapons/streaks/orange_long_streak"),
		Idstring("effects/payday2/particles/weapons/streaks/red_long_streak"),
		Idstring("effects/payday2/particles/weapons/streaks/violet_long_streak"),
		Idstring("effects/payday2/particles/weapons/streaks/white_long_streak"),
		Idstring("effects/payday2/particles/weapons/streaks/yellow_long_streak")
	}
	local ids_effect = Idstring("effect")
	for _, ids_load in pairs(ids_loads) do
		if DB:has(ids_effect, ids_load) then
			managers.dyn_resource:load(ids_effect, ids_load, managers.dyn_resource.DYN_RESOURCES_PACKAGE, nil)
		end
	end
end)