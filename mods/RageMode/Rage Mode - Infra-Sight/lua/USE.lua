_G.Rage_Special = _G.Rage_Special or {}
if not Utils:IsInHeist() then
	return
end
if Rage_Special.Rage_Point == Rage_Special.Rage_Point_Max and not Rage_Special.Activating then
	Rage_Special.Activating = true
	Rage_Special.Expire_Time = Application:time() + 10
end