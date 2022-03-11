local ThisModPath = ModPath or tostring(math.random())
local ThisModIds = Idstring(ThisModPath):key()
local __Name = function(__id)
	return "SALNS_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end
local Hook1 = __Name("update")
local Bool1 = __Name("IsSpwanDone")

Hooks:PostHook(PlayerStandard, "update", Hook1, function(self)
	if ((Network and Network:is_server()) or Global.game_settings.single_player) and not self[Bool1] then
		self[Bool1] = true
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
		local __nav_segments = managers.navigation._nav_segments
		for _, __nav in pairs(__nav_segments) do
			local unit_name = table.random(addon_loot_ready)
			local __unit = unit_name and World:spawn_unit(Idstring(unit_name), __nav.pos, Rotation()) or nil
			if __unit and __unit.interaction and __unit:interaction() then
				__unit:interaction():set_active(true, true)
			end
		end
	end
end)