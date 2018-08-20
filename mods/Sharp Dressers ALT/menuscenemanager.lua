if not PackageManager:loaded("packages/dlcs/sah/job_sah") then
	PackageManager:load("packages/dlcs/sah/job_sah") 
end

Hooks:PostHook(MenuSceneManager, "set_character_armor", "SharpDressers_set_character_armor", function(self, armor_id, unit)
	unit = unit or self._character_unit
	if managers.menu_component and not managers.menu_component._player_inventory_gui and managers.network and managers.network:session() and unit and unit:damage() and unit:damage():has_sequence("spawn_prop_tux") then
		unit:damage():run_sequence_simple("spawn_prop_tux")
	else
		if armor_id then
			unit:damage():run_sequence_simple(tweak_data.blackmarket.armors[armor_id].sequence)
		else
			unit:damage():run_sequence_simple(tweak_data.blackmarket.armors.level_1.sequence)
		end
	end
end)

Hooks:PostHook(MenuSceneManager, "set_henchmen_loadout", "SharpDressers_set_henchmen_loadout", function(self, index, character, loadout)
	local unit = self._henchmen_characters and self._henchmen_characters[index]
	if managers.menu_component and not managers.menu_component._player_inventory_gui and managers.network and managers.network:session() and unit and unit:damage() and unit:damage():has_sequence("spawn_prop_tux") then
		unit:damage():run_sequence_simple("spawn_prop_tux")
	else
		loadout = loadout or managers.blackmarket:henchman_loadout(index)
		local armor_id = loadout and loadout.armor
		if armor_id then
			unit:damage():run_sequence_simple(tweak_data.blackmarket.armors[armor_id].sequence)
		else
			unit:damage():run_sequence_simple(tweak_data.blackmarket.armors.level_1.sequence)
		end
	end
end)