core:module("CoreWorldDefinition")
core:import("CoreUnit")
core:import("CoreMath")
core:import("CoreEditorUtils")
core:import("CoreEngineAccess")
WorldDefinition = WorldDefinition or class()

if Network and Network:is_client() then

else
	local __pos_offset = function()
		local ang = math.random() * 360 * math.pi
		local rad = math.random(20, 30)
		return Vector3(math.cos(ang) * rad, math.sin(ang) * rad, 0)
	end
	local PossibleLevel = {
		["tag"] = {
			[Idstring("units/payday2/props/stn_prop_office_chair_regular/stn_prop_office_chair_regular"):key()] = Vector3(0, 0, 55),
			[Idstring("units/pd2_dlc_dah/props/dah_prop_vending_machine_b/dah_prop_vending_machine_b"):key()] = Vector3(0, 0, 185),
			[Idstring("units/pd2_dlc_dah/props/dah_prop_vending_machine_a/dah_prop_vending_machine_a"):key()] = Vector3(0, 0, 185),
			[Idstring("units/pd2_dlc1/architecture/res_int_motel/res_int_motel_vending_machine_01_illum"):key()] = Vector3(0, 0, 185),
			[Idstring("units/payday2/props/off_prop_officehigh_chair/off_prop_officehigh_chair_standard_black"):key()] = Vector3(0, 0, 55),
			[Idstring("units/world/architecture/hospital/props/chair_cafeteria/chair_cafeteria"):key()] = Vector3(0, 0, 40),
			[Idstring("units/pd2_dlc_dah/props/dah_prop_trash_can/dah_prop_trash_can"):key()] = Vector3(0, 0, 70),
			[Idstring("units/pd2_dlc_dah/props/dah_prop_plant/dah_prop_plant"):key()] = Vector3(0, 0, 60),
			[Idstring("units/pd2_dlc_cage/props/ind_prop_cardealership_armchair_set/ind_prop_cardealership_armchair"):key()] = Vector3(0, 0, 0),
			[Idstring("units/payday2/props/off_prop_officehigh_books/off_prop_officehigh_binder_07"):key()] = Vector3(0, 0, 0),
			[Idstring("units/payday2/props/off_prop_officehigh_books/off_prop_officehigh_binder_02"):key()] = Vector3(0, 0, 0),
			[Idstring("units/payday2/props/off_prop_officehigh_books/off_prop_officehigh_binder_06"):key()] = Vector3(0, 0, 0),
			[Idstring("units/world/props/office/copy_machine/copy_machine_03"):key()] = Vector3(0, 0, 100),
			[Idstring("units/pd2_dlc_chill/props/chl_prop_livingroom_bench_leather/chl_prop_livingroom_bench_leather"):key()] = Vector3(0, 0, 50),
			[Idstring("units/pd2_dlc_dah/props/dah_prop_plant_large_v2/dah_prop_plant_large_v2"):key()] = __pos_offset,
		}
	}
	if not Global.game_settings or not PossibleLevel[Global.game_settings.level_id] then

	else
		local PossibleList = PossibleLevel[Global.game_settings.level_id]
		Hooks:PostHook(WorldDefinition, "make_unit", "AddonLootSpawn", function(self, data, offset)
			if type(data) == "table" and data.name_id then
				local function __SpawnLoot(x_pos, x_rot)
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
					local unit = unit_name and World:spawn_unit(Idstring(unit_name), x_pos, x_rot) or nil
					if unit and unit.interaction and unit:interaction() then
						unit:interaction():set_active(true, true)
					end
				end
				if PossibleList and PossibleList[Idstring(tostring(data.name)):key()] then
					math.randomseed()
					math.randomseed()
					math.randomseed()
					math.randomseed()
					math.randomseed()
					math.randomseed()
					local fix_set = PossibleList[Idstring(tostring(data.name)):key()]
					local __pos = data.position + offset
					if type(fix_set) == "function" then
						__pos = __pos + fix_set()
					else
						__pos = __pos + fix_set
					end
					local __rot = Rotation(math.random()*360, 0, 0)
					__SpawnLoot(__pos, __rot)
				end
			end
		end)
	end
end