LegendaryArmours = LegendaryArmours or {}

local mod_ids = Idstring("Heavy Assault Suit"):key()

local func1 = "F_"..Idstring("set_equipped_player_style:"..mod_ids):key()

MenuSceneManager[func1] = function(armor_id, unit)
	armor_id = tostring(armor_id)
	if alive(unit) then
		local unit_damage = alive(unit) and unit:damage()
		if unit_damage then
			local armor_data = tweak_data.blackmarket.armors and tweak_data.blackmarket.armors[armor_id]
			if armor_data and armor_data.custom and armor_data.forced_las and LegendaryArmours and type(LegendaryArmours[tostring(armor_data.forced_las)]) == "table" then
				managers.blackmarket:set_equipped_player_style("las_"..tostring(armor_data.forced_las), managers.network and false or true)
			else
				if unit_damage:has_sequence(armor_data.sequence) then
					unit_damage:run_sequence_simple(armor_data.sequence)
				end
			end
		end
	end
	return
end

Hooks:PostHook(MenuSceneManager, "set_character_armor", "F_"..Idstring("set_character_armor:"..mod_ids):key(), function(self, armor_id, unit)
	unit = unit or self._character_unit
	self[func1](armor_id, unit)
end)