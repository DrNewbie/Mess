Hooks:PostHook(WeaponFactoryTweakData, "init", "F_"..Idstring("M203CC101Init"):key(), function(self)
	local dlc_data = Global.dlc_manager.all_dlc_data["bbq"]
	if not dlc_data.verified then
		self.parts.wpn_fps_ass_contraband_gl_m203_cc101 = {
			type = "underbarrel",
			sub_type = "grenade_launcher",
			name_id = "bm_wp_contraband_gl_m203",
			bullet_objects = {prefix = "g_grenade_", amount = 1},
			a_obj = "a_gl",
			unit = "units/pd2_dlc_chico/weapons/wpn_fps_ass_contraband_pts/wpn_fps_ass_contraband_gl_m203",
			stats = {value = 1},
			animations = {bipod_reload = "reload_ul"},
			perks = {
				"underbarrel"
			}
		}
	end
end)