Hooks:Add("BeardLibCreateScriptDataMods", Idstring("Dr_Newbie Payday Gang Enemies Package ReplaceScriptData"):key(), function()
	local _mods_replace_path = "assets/mod_overrides/Dr_Newbie Payday Gang Enemies Package/ScriptData/"
	BeardLib:ReplaceScriptData(_mods_replace_path.."ene_bulldozer_2.xml", "custom_xml", "units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2", "sequence_manager", {custom = true})
	BeardLib:ReplaceScriptData(_mods_replace_path.."ene_bulldozer_medic.xml", "custom_xml", "units/pd2_dlc_drm/characters/ene_bulldozer_medic/ene_bulldozer_medic", "sequence_manager", {custom = true})
	--BeardLib:ReplaceScriptData(_mods_replace_path.."ragdoll.xml", "custom_xml", "units/payday2/characters/ragdoll", "sequence_manager", {custom = true})
end)