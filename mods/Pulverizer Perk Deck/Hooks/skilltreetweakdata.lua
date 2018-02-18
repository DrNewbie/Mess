Hooks:PostHook(SkillTreeTweakData, "init", "PulverizerPerkDeckInit", function(self)
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
	table.insert(self.specializations, {
			custom = true,
			custom_id = "Pulverizer",
			name_id = "pulverizer_perk_name",
			desc_id = "pulverizer_perk_desc",
			{
				custom = true,
				upgrades = {
					"player_pulverizer_melee_event",
					"player_pulverizer_loss_ammo_1"
				},
				cost = 0,
				icon_xy = {
					2,
					7
				},
				name_id = "pulverizer_tier_1_name",
				desc_id = "pulverizer_tier_1_desc"
			},
			deck2,
			{
				custom = true,
				upgrades = {
					"player_pulverizer_health_regen",
					"player_pulverizer_armor_regen",
					"player_pulverizer_loss_ammo_2"
				},
				cost = 0,
				icon_xy = {
					2,
					7
				},
				name_id = "pulverizer_tier_3_name",
				desc_id = "pulverizer_tier_3_desc"
			},
			deck4,
			{
				custom = true,
				upgrades = {
					"player_pulverizer_reduce_melee_charge",
					"player_pulverizer_reduce_melee_delay",
					"player_pulverizer_loss_ammo_3"
				},
				cost = 0,
				icon_xy = {
					2,
					7
				},
				name_id = "pulverizer_tier_5_name",
				desc_id = "pulverizer_tier_5_desc"
			},
			deck6,
			{
				custom = true,
				upgrades = {
					"player_pulverizer_run_and_punch",
					"player_pulverizer_loss_ammo_4"
				},
				cost = 0,
				icon_xy = {
					2,
					7
				},
				name_id = "pulverizer_tier_7_name",
				desc_id = "pulverizer_tier_7_desc"
			},
			deck8,
			{
				custom = true,
				upgrades = {
					"player_pulverizer_damage_stack",
					"player_passive_loot_drop_multiplier",
					"player_pulverizer_loss_ammo_5"
				},
				cost = 0,
				icon_xy = {
					2,
					7
				},
				name_id = "pulverizer_tier_9_name",
				desc_id = "pulverizer_tier_9_desc"
			}
		}
	)
end)