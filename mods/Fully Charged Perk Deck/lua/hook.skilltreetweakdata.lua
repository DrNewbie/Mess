Hooks:PostHook(SkillTreeTweakData, "init", "FullyChargedPerkDeckInit", function(self)
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
			custom_id = "Fully Charged",
			name_id = "fullycharged_perk_name",
			desc_id = "fullycharged_perk_desc",
			{
				custom = true,
				upgrades = {
					"player_fully_charged_armor2damage",
					"player_fully_charged_invulnerable"
				},
				cost = 0,
				icon_xy = {
					3,
					0
				},
				name_id = "fullycharged_tier_1_name",
				desc_id = "fullycharged_tier_1_desc"
			},
			deck2,
			{
				custom = true,
				upgrades = {
					"player_fully_charged_far2damage"
				},
				cost = 0,
				icon_xy = {
					6,
					0
				},
				name_id = "fullycharged_tier_3_name",
				desc_id = "fullycharged_tier_3_desc"
			},
			deck4,
			{
				custom = true,
				upgrades = {
					"player_tier_armor_multiplier_1",
					"player_tier_armor_multiplier_2",
					"player_fully_charged_explosive_headshot_1"
				},
				cost = 0,
				icon_xy = {
					6,
					0
				},
				name_id = "fullycharged_tier_5_name",
				desc_id = "fullycharged_tier_5_desc"
			},
			deck6,
			{
				custom = true,
				upgrades = {
					"player_tier_armor_multiplier_3",
					"player_fully_charged_explosive_headshot_2"
				},
				cost = 0,
				icon_xy = {
					6,
					0
				},
				name_id = "fullycharged_tier_7_name",
				desc_id = "fullycharged_tier_7_desc"
			},
			deck8,
			{
				custom = true,
				upgrades = {
					"player_fully_charged_headshot_ony",
					"player_fully_charged_time2damage",
					"player_passive_loot_drop_multiplier"
				},
				cost = 0,
				texture = "guis/textures/pd2/skilltree_2/icons_atlas_2",
				icon_xy = {9*80, 11*80, 80, 80},
				name_id = "fullycharged_tier_9_name",
				desc_id = "fullycharged_tier_9_desc"
			}
		}
	)
end)