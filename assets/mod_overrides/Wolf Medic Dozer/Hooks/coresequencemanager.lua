Hooks:Add("BeardLibCreateScriptDataMods", "WolfMedicDozer_ReplaceScriptData", function()
	BeardLib:ReplaceScriptData("assets/mod_overrides/Wolf Medic Dozer/ScriptData/ene_bulldozer_medic.xml", "custom_xml", "units/pd2_dlc_drm/characters/ene_bulldozer_medic/ene_bulldozer_medic", "sequence_manager", {custom = true})
end)