if tweak_data and tweak_data.weapon then
	for weapon_name, weapon_data in pairs(tweak_data.weapon) do
		if weapon_name:find('crew') and weapon_data.use_data.selection_index == 1 then
			tweak_data.weapon[weapon_name].use_data.selection_index = 2
		end
	end
end