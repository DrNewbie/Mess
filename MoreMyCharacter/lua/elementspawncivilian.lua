core:import("CoreMissionScriptElement")
ElementSpawnCivilian = ElementSpawnCivilian or class(CoreMissionScriptElement.MissionScriptElement)

_G.MoreMyCharacter = _G.MoreMyCharacter or {}
MoreMyCharacter = _G.MoreMyCharacter
MoreMyCharacter.Unit_Name = MoreMyCharacter.Unit_Name or ""

Hooks:PreHook(ElementSpawnCivilian, "produce", "MoreMyCharacter", function(Civ, ...)
	if MoreMyCharacter.Unit_Name == "" and Global.blackmarket_manager and Global.blackmarket_manager._preferred_character then
		if tweak_data and tweak_data.safehouse then
			local _local_character_name = Global.blackmarket_manager._preferred_character
			local _unit_name_table = {
				russian = "dallas",
				spanish = "chains",
				german = "wolf",
				american = "houston",
				old_hoxton = "old_hoxton",
				jowi = "john_wick",
				female_1 = "clover",
				sydney = "sydney",
				dragan = "dragan",
				jacket = "jacket",
				bonnie = "bonnie",
				sokol = "sokol",
				dragon = "dragon",
				bodhi = "bodhi",
				jimmy = "jimmy",
				sydney = "sydney",
				wild = "wild"
			}
			local _name2use = _unit_name_table[_local_character_name] or ""
			if _name2use ~= "" then
				MoreMyCharacter.Unit_Name = "units/pd2_dlc_chill/characters/npc_criminal_".. _name2use .."/npc_criminal_".. _name2use ..""
			end
		end
	end
	if MoreMyCharacter.Unit_Name ~= "" then
		Civ._enemy_name = Idstring(MoreMyCharacter.Unit_Name)
	end
end )