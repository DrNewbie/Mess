function PBiMM:OptChanged()
	if MenuSceneManager and MenuSceneManager.PBiMM and alive(MenuSceneManager.PBiMM) then
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

function PBiMM:IsMovingChanged()
	if MenuSceneManager.PBiMM:damage() then
		if PBiMM.Options:GetValue("__is_moving") then
			if MenuSceneManager.PBiMM:damage():has_sequence("anim_pig_idle") then
				MenuSceneManager.PBiMM:damage():run_sequence_simple("anim_pig_idle")
			end
		else
			MenuSceneManager:__SpawnPBiMM()
			PBiMM:OptChanged()
		end
	end
end