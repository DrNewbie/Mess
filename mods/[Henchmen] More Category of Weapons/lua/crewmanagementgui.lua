function CrewManagementGui:populate_primaries(henchman_index, data, gui)
	gui:populate_weapon_category_new(data)
	local loadout = managers.blackmarket:henchman_loadout(henchman_index)
	for k, v in ipairs(data) do
		local tweak = tweak_data.weapon[v.name]
		v.equipped = loadout.primary_slot == v.slot
		if v.equipped then
			v.buttons = {"w_unequip"}
		elseif not v.empty_slot then
			v.buttons = {"w_equip"}
		end
		v.comparision_data = nil
		v.mini_icons = nil
	end
end