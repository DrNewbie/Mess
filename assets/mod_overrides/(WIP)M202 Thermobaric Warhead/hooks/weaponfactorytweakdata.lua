Hooks:PostHook(WeaponFactoryTweakData, "init", "M202Incen_WeaponFactoryTweakData_init", function(self)
	local dlc_data = Global.dlc_manager.all_dlc_data["bbq"]	
	self.parts.wpn_fps_gre_ray_incen.custom_stats = {
		launcher_grenade = "rocket_ray_frag_incen"
	}
	self.parts.wpn_fps_gre_ray_incen.desc_id = "bm_wp_wpn_fps_gre_ray_incen_desc"	
	if not dlc_data.verified then
	self.parts.wpn_fps_gre_ray_incen = {
		stats = {damage = -50},
		custom_stats = nil
	}
	end
end)