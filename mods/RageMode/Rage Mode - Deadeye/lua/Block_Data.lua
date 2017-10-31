_G.Rage_Special = _G.Rage_Special or {}

Hooks:PostHook(PlayerMovement, "change_state", "PlayerMovementchange_state_Deadeye", function(plym, name)	
	if name == "empty" or name == "mask_off" or name == "bleed_out" or name == "fatal" or name == "arrested" or name == "incapacitated" then
		Rage_Special:Clean()
	end
end)