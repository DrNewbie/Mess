function CrewManagementGui:populate_ability(henchman_index, data, gui)
	local abilities = {}
	for ability_name in pairs(tweak_data.upgrades.crew_ability_definitions) do
		table.insert(abilities, ability_name)
	end
	self:populate_custom("ability", henchman_index, tweak_data.upgrades.crew_ability_definitions, abilities, data, gui)
end