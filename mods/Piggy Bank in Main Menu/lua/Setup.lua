function PBiMM:is_PBiMM_alive()
	if MenuSceneManager and MenuSceneManager.PBiMM and alive(MenuSceneManager.PBiMM) then
		return true
	end
	return false
end

function PBiMM:OptChanged()
	if PBiMM:is_PBiMM_alive() then
		MenuSceneManager.PBiMM:set_position(Vector3(
			PBiMM.Options:GetValue("__pos_x"),
			PBiMM.Options:GetValue("__pos_y"),
			PBiMM.Options:GetValue("__pos_z")
		))
		MenuSceneManager.PBiMM:set_rotation(Rotation(
			PBiMM.Options:GetValue("__rot_x"),
			PBiMM.Options:GetValue("__rot_y"),
			PBiMM.Options:GetValue("__rot_z")
		))
	end
	return
end

function PBiMM:MovingSpeedChanged()
	if PBiMM:is_PBiMM_alive() and MenuSceneManager.PBiMM:anim_state_machine() then
		local current_state_name = MenuSceneManager.PBiMM:anim_state_machine():segment_state(Idstring("base"))
		if current_state_name then
			MenuSceneManager.PBiMM:anim_state_machine():set_speed(current_state_name, PBiMM.Options:GetValue("__moving_speed"))
		end
	end
	return
end

function PBiMM:IsMovingChanged()
	if PBiMM:is_PBiMM_alive() and MenuSceneManager.PBiMM:damage() then
		if PBiMM.Options:GetValue("__is_moving") then
			if MenuSceneManager.PBiMM:damage():has_sequence("anim_pig_idle") then
				MenuSceneManager.PBiMM:damage():run_sequence_simple("anim_pig_idle")
				PBiMM:MovingSpeedChanged()
			end
		else
			MenuSceneManager:__SpawnPBiMM()
			PBiMM:OptChanged()
		end
	end
end