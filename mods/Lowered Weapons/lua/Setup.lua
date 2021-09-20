local mod_ids = Idstring(ModPath):key()
local __dt1 = "F"..Idstring("__dt1::"..mod_ids):key()
local bool1 = "F"..Idstring("bool1::"..mod_ids):key()

function LLWepF:OptChanged()
	if not type(LLWepF) == "table" or not type(LLWepF.Options) == "table" or not type(LLWepF.Options.GetValue) == "function" then
		return
	end
	
	local local_player = managers.player:local_player()
	if not local_player then
		return
	end
	
	local PlyStandard = local_player and local_player:movement() and local_player:movement()._states.standard or nil
	
	if not PlyStandard then
		return
	end
	
	LLWepF.ForcedApplyToFov = true
end

function LLWepF:ResetToDefault()
	if not type(LLWepF) == "table" or not type(LLWepF.Options) == "table" or not type(LLWepF.Options.SetValue) == "function" then
		return
	end
	
	LLWepF.Options:SetValue("__time_delay", 3)
	LLWepF.Options:SetValue("__time_speed", 1)
	
	LLWepF.Options:SetValue("__offset_pos_x", 10)
	LLWepF.Options:SetValue("__offset_pos_y", 10)
	LLWepF.Options:SetValue("__offset_pos_z", -5)
	LLWepF.Options:SetValue("__offset_rot_x", 66)
	LLWepF.Options:SetValue("__offset_rot_y", 0)
	LLWepF.Options:SetValue("__offset_rot_z", 0)
	
	QuickMenu:new(
		managers.localization:to_upper_text("lw_ff_opt_menu_name"),
		managers.localization:to_upper_text("lw_ff_opt_after_reset_default"),
		{
			{
				text = managers.localization:to_upper_text("lw_ff_opt_after_reset_default_ok"),
				is_cancel_button = true
			}
		},
		true
	):Show()
	
	LLWepF:OptChanged()
end