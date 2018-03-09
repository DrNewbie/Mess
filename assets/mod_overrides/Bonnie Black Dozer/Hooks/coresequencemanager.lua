Hooks:Add("BeardLibCreateScriptDataMods", "BonnieDozer_ReplaceScriptData", function()
	BeardLib:ReplaceScriptData("assets/mod_overrides/Bonnie Black Dozer/ScriptData/ene_bulldozer_2.xml", "custom_xml", "units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2", "sequence_manager", {custom = true})
end)