function ModsCounterLLL:OptChanged()
	if MenuSceneManager and type(MenuSceneManager.ModsCounterLLLOptChanged) == "function" then
		MenuSceneManager:ModsCounterLLLOptChanged()
	end
	return
end

function ModsCounterLLL:Reset()
	ModsCounterLLL.Options:SetValue("__title_pos_x", ModsCounterLLL.Options:GetDefaultValue("__title_pos_x"))
	ModsCounterLLL.Options:SetValue("__title_pos_y", ModsCounterLLL.Options:GetDefaultValue("__title_pos_y"))
	ModsCounterLLL.Options:SetValue("__title_pos_z", ModsCounterLLL.Options:GetDefaultValue("__title_pos_z"))
	ModsCounterLLL.Options:SetValue("__title_rot_x", ModsCounterLLL.Options:GetDefaultValue("__title_rot_x"))
	ModsCounterLLL.Options:SetValue("__title_rot_y", ModsCounterLLL.Options:GetDefaultValue("__title_rot_y"))
	ModsCounterLLL.Options:SetValue("__title_rot_z", ModsCounterLLL.Options:GetDefaultValue("__title_rot_z"))
	ModsCounterLLL.Options:SetValue("__counter_pos_x", ModsCounterLLL.Options:GetDefaultValue("__counter_pos_x"))
	ModsCounterLLL.Options:SetValue("__counter_pos_y", ModsCounterLLL.Options:GetDefaultValue("__counter_pos_y"))
	ModsCounterLLL.Options:SetValue("__counter_pos_z", ModsCounterLLL.Options:GetDefaultValue("__counter_pos_z"))
	ModsCounterLLL.Options:SetValue("__counter_rot_x", ModsCounterLLL.Options:GetDefaultValue("__counter_rot_x"))
	ModsCounterLLL.Options:SetValue("__counter_rot_y", ModsCounterLLL.Options:GetDefaultValue("__counter_rot_y"))
	ModsCounterLLL.Options:SetValue("__counter_rot_z", ModsCounterLLL.Options:GetDefaultValue("__counter_rot_z"))
	ModsCounterLLL:OptChanged()
	return
end