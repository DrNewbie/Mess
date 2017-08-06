Announcer:AddHostMod("Taser Frag , Replace normal frag to 'Taser Frag'")

Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_TaserFrag", function(loc)
	for _, filename in pairs(file.GetFiles("mods/Taser Frag/loc/")) do
		local str = filename:match('^(.*).txt$')
		if str and Idstring(str) and Idstring(str):key() == SystemInfo:language():key() then
			loc:load_localization_file("mods/Taser Frag/loc/" .. filename)
			break
		end
	end
	loc:load_localization_file("mods/Taser Frag/loc/english.txt", false)
end)