local _name = ''
for i = 1, 3 do
	_name = 'crew_4maskach_' .. i
	tweak_data.upgrades.values.team[_name] = {true}	
	tweak_data.upgrades.crew_ability_definitions[_name] = {
		name_id = "menu_crew_4maskach",
		icon = "equipment_ticket"
	}
end

_name = nil