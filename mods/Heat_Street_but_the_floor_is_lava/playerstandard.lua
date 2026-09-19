local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local Func1 = "F_"..Idstring("Func1::"..ThisModIds):key()
local Delay1 = "F_"..Idstring("Delay1::"..ThisModIds):key()
local Look4Floor = {
	[Idstring('units/payday2/architecture/com_ext_parking_garage/com_ext_parking_garage_decal_a_4m'):key()] = true,
	[Idstring('units/payday2/architecture/com_ext_parking_garage/com_ext_parking_garage_decal_a_spot_4m'):key()] = true,
	[Idstring('units/payday2/architecture/res_ext_apartment/res_ext_debris'):key()] = true,
	[Idstring('units/payday2/props/str_prop_street_planter/str_prop_street_planter_b'):key()] = true,
	[Idstring('units/pd2_dlc_flat/props/flt_prop_streetplanters_ground/flt_prop_streetplanters_ground_small'):key()] = true,
	[Idstring('units/pd2_dlc_run/architecture/run_ext_consulate_exit/run_ext_consulate_exit'):key()] = true,
	[Idstring('units/pd2_dlc_run/architecture/run_ext_ground_road/run_ext_ground_asphalt_20x20m'):key()] = true,
	[Idstring('units/pd2_dlc_run/architecture/run_ext_ground_road/run_ext_ground_asphalt_20x40m'):key()] = true,
	[Idstring('units/pd2_dlc_run/architecture/run_ext_ground_road/run_ext_ground_road_16x40'):key()] = true,
	[Idstring('units/pd2_dlc_run/architecture/run_ext_ground_road/run_ext_ground_road_20x10'):key()] = true,
	[Idstring('units/pd2_dlc_run/architecture/run_ext_ground_road/run_ext_ground_road_20x20'):key()] = true,
	[Idstring('units/pd2_dlc_run/architecture/run_ext_ground_road/run_ext_ground_road_20x80'):key()] = true,
	[Idstring('units/pd2_dlc_run/architecture/run_ext_ground_road/run_ext_ground_road_crossing_16m'):key()] = true,
	[Idstring('units/pd2_dlc_run/architecture/run_ext_ground_road/run_ext_ground_road_crossing_16x20m'):key()] = true,
	[Idstring('units/pd2_dlc_run/architecture/run_ext_ground_road/run_ext_ground_road_crossing_20x20m'):key()] = true,
	[Idstring('units/pd2_dlc_run/architecture/run_ext_ground_road/run_ext_ground_sidewalk_10x10m'):key()] = true,
	[Idstring('units/pd2_dlc_run/architecture/run_ext_ground_road/run_ext_ground_sidewalk_10x20m'):key()] = true,
	[Idstring('units/pd2_dlc_run/architecture/run_ext_ground_road/run_ext_ground_sidewalk_20_15m'):key()] = true,
	[Idstring('units/pd2_dlc_run/architecture/run_ext_ground_road/run_ext_ground_sidewalk_20x20m'):key()] = true,
	[Idstring('units/pd2_dlc_run/architecture/run_ext_loading_dock_01/run_ext_loading_dock_01'):key()] = true,
	[Idstring('units/pd2_dlc_run/architecture/run_ext_loading_dock_01/run_ext_loading_ramp_01'):key()] = true,
	[Idstring('units/pd2_dlc_run/architecture/run_ext_street_alley/run_ext_street_alley'):key()] = true,
	[Idstring('units/pd2_dlc_run/architecture/run_ext_street_alley/run_ext_street_alley_a'):key()] = true,
	[Idstring('units/pd2_dlc_run/architecture/run_ext_street_alley/run_ext_street_alley_b'):key()] = true,
	[Idstring('units/pd2_dlc_run/architecture/run_ext_tunnel/run_ext_tunnel'):key()] = true,
	[Idstring('units/pd2_dlc_run/architecture/run_int_street_alley/run_int_street_alley'):key()] = true,
	[Idstring('units/world/architecture/street/decals/ground/decal_ground_grate2'):key()] = true,
	[Idstring('units/world/architecture/street/decals/ground/decal_ground_grate3'):key()] = true,
	[Idstring('units/world/architecture/street/decals/ground/decal_ground_grate4'):key()] = true,
	[Idstring('units/world/architecture/street/decals/ground/decal_ground_manhole_big'):key()] = true,
	[Idstring('units/world/vegetation/forest/zones/forest/zone_forrest_bush_1/zone_forrest_bush_1'):key()] = true,
	[Idstring('units/world/vegetation/ground_grass/street_alley_grass'):key()] = true,
	[Idstring('units/world/vegetation/jungle/foliage_mini_roof_a'):key()] = true
}

Hooks:PostHook(PlayerStandard, "_update_check_actions", "F_"..Func1, function(self, t, dt)
	if Utils and self._unit and self._ext_damage and managers.job:current_level_id() == "run" then
		if not self[Delay1] then
			self[Delay1] = dt + 0.1
			local __col_rayy = World:raycast("ray", self._unit:movement():m_pos(), self._unit:movement():m_pos() - Vector3(0, 0, 30), "slot_mask", managers.slot:get_mask("world_geometry"))
			if __col_rayy and __col_rayy.unit and alive(__col_rayy.unit) and Look4Floor[__col_rayy.unit:name():key()] then
				self[Delay1] = 1.5
				local __fire_params = {
					sound_event = "molotov_impact",
					range = 15,
					curve_pow = 3,
					damage = 1,
					fire_alert_radius = 1500,
					alert_radius = 1500,
					sound_event_burning = "burn_loop_gen",
					is_molotov = true,
					player_damage = 2,
					sound_event_impact_duration = 1,
					burn_tick_period = 0.25,
					burn_duration = 1,
					effect_name = "effects/payday2/particles/explosions/molotov_grenade",
					fire_dot_data = {
						dot_trigger_chance = 35,
						dot_damage = 15,
						dot_length = 1,
						dot_trigger_max_distance = 3000,
						dot_tick_period = 0.25
					}
				}
				self._ext_damage:damage_simple({
					variant = "delayed_tick",
					damage = 2
				})
				EnvironmentFire.spawn(self._unit:movement():m_pos(), Rotation(), __fire_params, math.UP, nil, 0, 1)
			end
		else
			self[Delay1] = self[Delay1] - dt
			if self:running() then
				self[Delay1] = self[Delay1] - dt * 0.5
			end
			if self[Delay1] <= 0 or self._is_jumping then
				self[Delay1] = nil
			end
		end
	end
end)