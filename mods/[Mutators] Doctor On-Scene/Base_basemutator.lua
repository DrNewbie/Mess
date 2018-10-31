_G.TMP_mutator_saving = _G.TMP_mutator_saving or {}


Hooks:Add("LocalizationManagerPostInit", "MutatorDoctorOnScene_LocInit", function()
	LocalizationManager:add_localized_strings({
		["mutator_doctoronscene"] = "Doctor On-Scene",
		["mutator_doctoronscene_desc"] = "Only medics and medic bulldozers spawn now",
		["mutator_doctoronscene_longdesc"] = "Only medics and medic bulldozers spawn now"
	})
end)

MutatorDoctorOnScene = MutatorDoctorOnScene or class(MutatorMediDozer)
MutatorDoctorOnScene._type = "MutatorDoctorOnScene"
MutatorDoctorOnScene.name_id = "mutator_doctoronscene"
MutatorDoctorOnScene.desc_id = "mutator_doctoronscene_desc"
MutatorDoctorOnScene.has_options = false
MutatorDoctorOnScene.reductions = {money = 0, exp = 0}
MutatorDoctorOnScene.icon_coords = {10, 1}
MutatorDoctorOnScene.incompatibility_tags = {"replaces_units"}

function MutatorDoctorOnScene:modify_unit_categories(group_ai_tweak, difficulty_index)
	group_ai_tweak.special_unit_spawn_limits = {
		tank = math.huge,
		taser = 0,
		spooc = 0,
		shield = 0,
		medic = math.huge
	}
	for group, units_data in pairs(group_ai_tweak.unit_categories) do
		if group == "Phalanx_minion" or group == "Phalanx_vip" or units_data.is_captain then
		
		else
			for group_sub, units_data_sub in pairs(group_ai_tweak.unit_categories[group].unit_types) do
				group_ai_tweak.unit_categories[group].unit_types[group_sub] = {
					Idstring("units/payday2/characters/ene_medic_m4/ene_medic_m4"),
					Idstring("units/payday2/characters/ene_medic_r870/ene_medic_r870"),
					Idstring("units/payday2/characters/ene_medic_m4/ene_medic_m4"),
					Idstring("units/payday2/characters/ene_medic_r870/ene_medic_r870"),
					Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_medic/ene_bulldozer_medic")
				}
			end
		end
	end
end