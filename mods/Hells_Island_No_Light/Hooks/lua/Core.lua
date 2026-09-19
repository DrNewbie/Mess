local ThisModPath = ModPath

Hooks:Add("BeardLibCreateScriptDataMods", "F_"..Idstring("BeardLibCreateScriptDataMods:Hell Island No Light"):key(), function()
	if Global.load_level == true and Global.level_data.level_id == "bph" then 
		BeardLib:ReplaceScriptData(ThisModPath.."/scriptdata/bph_new_lights2.xml", "custom_xml", "levels/narratives/locke/bph/lights2/lights2", "continent", {custom = true})
	end
end)