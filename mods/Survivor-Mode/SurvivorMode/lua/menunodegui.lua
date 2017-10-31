if Network:is_client() then
	return
end

_G.SurvivorModeBase = _G.SurvivorModeBase or {}

function SurvivorModeBase:Mod_Enable_Warning_Host ()
	if SurvivorModeBase.Enable and not SurvivorModeBase.Mod_Enable_Warning_Done then
		QuickMenu:new(
			"[!!Warning!!]",
			"'Survivor Mode' is enable now, you should only play with your friends.",
			{
				{
					text = "ok",
					is_cancel_button = true
				}
			},
			true
		)
		SurvivorModeBase.Mod_Enable_Warning_Done = true
	end
end