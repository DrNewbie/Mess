Hooks:PostHook(SkillTreeTweakData, "init", "CriticalPerkDeckInit", function(self)
	local deck2 = {
		cost = 0,
		desc_id = "menu_deckall_2_desc",
		name_id = "menu_deckall_2",
		upgrades = {"weapon_passive_headshot_damage_multiplier"},
		icon_xy = {
			1,
			0
		}
	}
	local deck4 = {
		cost = 0,
		desc_id = "menu_deckall_4_desc",
		name_id = "menu_deckall_4",
		upgrades = {
			"passive_player_xp_multiplier",
			"player_passive_suspicion_bonus",
			"player_passive_armor_movement_penalty_multiplier"
		},
		icon_xy = {
			3,
			0
		}
	}
	local deck6 = {
		cost = 0,
		desc_id = "menu_deckall_6_desc",
		name_id = "menu_deckall_6",
		upgrades = {
			"armor_kit",
			"player_pick_up_ammo_multiplier"
		},
		icon_xy = {
			5,
			0
		}
	}
	local deck8 = {
		cost = 0,
		desc_id = "menu_deckall_8_desc",
		name_id = "menu_deckall_8",
		upgrades = {
			"weapon_passive_damage_multiplier",
			"passive_doctor_bag_interaction_speed_multiplier"
		},
		icon_xy = {
			7,
			0
		}
	}
	local pc1, pc3, pc5, pc7, pc9 = 0, 0, 0, 0, 0
	local pdcb = "player_passive_loot_drop_multiplier"
	table.insert(self.specializations, {
			custom = true,
			custom_id = "Critical",
			name_id = "critical_perk_name",
			desc_id = "critical_perk_desc",
			{
				custom = true,
				upgrades = {
					"player_critical_to_all"
				},
				cost = pc1,
				texture = "guis/textures/pd2/skilltree_2/icons_atlas_2",
				icon_xy = {9*80, 9*80},
				grow = {-24, -24},
				name_id = "critical_tier_1_name",
				desc_id = "critical_tier_1_desc"
			},
			deck2,
			{
				custom = true,
				upgrades = {
					"player_critical_tier_1",
					"player_ct_reload_speed_multiplier_1"
				},
				cost = pc3,
				texture = "guis/textures/pd2/skilltree_2/icons_atlas_2",
				icon_xy = {0*80, 12*80},
				grow = {-24, -24},
				name_id = "critical_tier_3_name",
				desc_id = "critical_tier_3_desc"
			},
			deck4,
			{
				custom = true,
				upgrades = {
					"player_critical_tier_2",
					"player_ct_reload_speed_multiplier_2"
				},
				cost = pc5,
				texture = "guis/textures/pd2/skilltree_2/icons_atlas_2",
				icon_xy = {0*80, 12*80},
				grow = {-24, -24},
				name_id = "critical_tier_5_name",
				desc_id = "critical_tier_5_desc"
			},
			deck6,
			{
				custom = true,
				upgrades = {
					"player_critical_gain_health_1"
				},
				cost = pc7,
				texture = "guis/textures/pd2/skilltree_2/icons_atlas_2",
				icon_xy = {11*80, 4*80},
				grow = {-24, -24},
				name_id = "critical_tier_7_name",
				desc_id = "critical_tier_7_desc"
			},
			deck8,
			{
				custom = true,
				upgrades = {
					"player_critical_gain_health_2"
				},
				cost = pc9,
				texture = "guis/textures/pd2/skilltree_2/icons_atlas_2",
				icon_xy = {11*80, 4*80},
				grow = {-24, -24},
				name_id = "critical_tier_9_name",
				desc_id = "critical_tier_9_desc"
			}
		}
	)
end)