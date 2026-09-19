Hooks:PostHook(GageAssignmentManager, "_setup", "GagePackage2RandomLootInit", function(self)
	local gnum = self._tweak_data:get_num_assignment_units()
	if gnum and gnum > 1 then
		self._tweak_data.get_num_assignment_units = function()
			return gnum * 3
		end
	end
end)

Hooks:PostHook(GageAssignmentManager, "do_spawn", "GagePackage2RandomLootSpawn", function(self, position, rotation)
	if (Network:is_server() or Global.game_settings.single_player) and position and rotation then
		math.randomseed(tostring(os.time()):reverse():sub(1, 6))
		local addon_loot = {
			"units/payday2/equipment/gen_interactable_weapon_case_2x1/gen_interactable_weapon_case_2x1",
			"units/payday2/equipment/ind_interactable_hardcase_loot/ind_interactable_hardcase_loot_cocaine",
			"units/payday2/equipment/ind_interactable_hardcase_loot/ind_interactable_hardcase_loot_gold",
			"units/payday2/equipment/ind_interactable_hardcase_loot/ind_interactable_hardcase_loot_money",
			"units/payday2/pickups/gen_pku_artifact_statue/gen_pku_artifact_statue",
			"units/payday2/pickups/gen_pku_bucket_of_money/gen_pku_bucket_of_money",
			"units/payday2/pickups/gen_pku_cocaine/gen_pku_cocaine",
			"units/payday2/pickups/gen_pku_cocaine/gen_pku_cocaine_pure",
			"units/payday2/pickups/gen_pku_gold/gen_pku_gold",
			"units/payday2/pickups/gen_pku_money_luggage/gen_pku_luggage_money_pile",
			"units/payday2/props/bnk_prop_vault_loot/bnk_prop_vault_loot_special_gold",
			"units/payday2/props/bnk_prop_vault_loot/bnk_prop_vault_loot_special_money",
			"units/payday2/props/com_prop_jewelry_jewels/com_prop_jewelry_box_01",
			"units/payday2/props/com_prop_jewelry_jewels/com_prop_jewelry_box_02",
			"units/payday2/props/com_prop_jewelry_jewels/com_prop_jewelry_box_03",
			"units/payday2/props/com_prop_jewelry_jewels/com_prop_jewelry_box_04",
			"units/payday2/props/gen_prop_bank_atm_standing/gen_prop_bank_atm_standing",
			"units/pd2_dlc_arena/pickups/gen_pku_money_plasic_wrapped/gen_pku_money_plasic_wrapped",
			"units/pd2_dlc_berry/pickups/bry_pku_lost_artifact/bry_pku_lost_artifact",
			"units/pd2_dlc_berry/pickups/bry_pku_prototype_box/bry_pku_prototype_box",
			"units/pd2_dlc_cane/equipment/cne_prop_christmas_gift_multi/cne_prop_christmas_gift_multi",
			"units/pd2_dlc_dark/equipment/drk_interactable_weapon_case_1x1/drk_interactable_weapon_case_1x1",
			"units/pd2_dlc_mad/props/mad_prop_compound_test_subject/mad_prop_compound_test_subject_01",
			"units/pd2_dlc_pal/pickups/pal_pku_money_stack_huge/pal_pku_money_stack_huge",
			"units/pd2_indiana/props/mus_prop_exhibit_b_pottery_b/mus_prop_exhibit_b_pottery_b",
			"units/pd2_mcmansion/props/mcm_prop_evidence_box/mcm_prop_evidence_box",
		}
		local addon_loot_ready = {}
		for _, loot in pairs(addon_loot) do
			if PackageManager:unit_data(Idstring(loot)) then
				table.insert(addon_loot_ready, loot)
			end
		end
		local unit_name = table.random(addon_loot_ready)
		local unit = unit_name and World:spawn_unit(Idstring(unit_name), position, rotation) or nil
		if unit and unit.interaction and unit:interaction() then
			unit:interaction():set_active(true, true)
		end
	end
end)