_G.Rage_Special = _G.Rage_Special or {}
if not Utils:IsInHeist() then
	return
end
if Rage_Special.Rage_Point == Rage_Special.Rage_Point_Max and not Rage_Special.Activating then
	Rage_Special.Mark_List = {}
	Rage_Special.Block_SomeThing = false
	Rage_Special.Block_SomeThing_Time = 0
	Rage_Special.Activating = true
	Rage_Special.Expire_Time = Application:time() + Rage_Special.Ready_Time
	managers.hud:show_interaction_bar(0, Rage_Special.Ready_Time)
end