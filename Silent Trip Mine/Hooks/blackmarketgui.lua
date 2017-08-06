function BlackMarketGui:populate_deployables(data)
	local new_data = {}
	local _tmp_new_data = {}
	local sort_data = managers.blackmarket:get_sorted_deployables()
	local max_items = math.ceil(#sort_data / (data.override_slots[1] or 3)) * (data.override_slots[1] or 3)
	for i = 1, max_items do
		data[i] = nil
	end
	local guis_catalog = "guis/"
	local index = 0
	local second_deployable = managers.player:has_category_upgrade("player", "second_deployable")
	for i, deployable_data in ipairs(sort_data) do
		guis_catalog = "guis/"
		local bundle_folder = tweak_data.blackmarket.deployables[deployable_data[1]] and tweak_data.blackmarket.deployables[deployable_data[1]].texture_bundle_folder
		if bundle_folder then
			guis_catalog = guis_catalog .. "dlcs/" .. tostring(bundle_folder) .. "/"
		end
		new_data = {}
		new_data.name = deployable_data[1]
		new_data.name_localized = managers.localization:text(tweak_data.blackmarket.deployables[new_data.name].name_id)
		new_data.category = "deployables"
		new_data.bitmap_texture = guis_catalog .. "textures/pd2/blackmarket/icons/deployables/" .. tostring(new_data.name)
		new_data.slot = i
		new_data.unlocked = table.contains(managers.player:availible_equipment(1), new_data.name)
		if new_data.name == "trip_mine_silent" then
			new_data.unlocked = _tmp_new_data.unlocked
		elseif new_data.name == "trip_mine" then
			_tmp_new_data.unlocked = new_data.unlocked
		end
		new_data.level = 0
		new_data.equipped = managers.blackmarket:equipped_deployable() == new_data.name
		local slot = 0
		local count = 1
		if second_deployable then
			count = 2
		end
		for i = 1, count do
			if managers.player:equipment_in_slot(i) == new_data.name then
				slot = i
				break
			end
		end
		new_data.slot = slot
		new_data.equipped = slot ~= 0
		if new_data.equipped and second_deployable and new_data.unlocked then
			if slot == 1 then
				new_data.equipped_text = managers.localization:to_upper_text("bm_menu_primaries")
			end
			if slot == 2 then
				new_data.equipped_text = managers.localization:to_upper_text("bm_menu_secondaries")
			end
		end
		if not new_data.unlocked then
			new_data.equipped_text = ""
		end
		new_data.stream = false
		new_data.skill_based = new_data.level == 0
		new_data.skill_name = "bm_menu_skill_locked_" .. new_data.name
		new_data.lock_texture = self:get_lock_icon(new_data)
		if new_data.unlocked and not new_data.equipped and not second_deployable then
			table.insert(new_data, "lo_d_equip")
		end
		if new_data.unlocked and not new_data.equipped and second_deployable then
			table.insert(new_data, "lo_d_equip_primary")
		end
		if second_deployable and managers.blackmarket:equipped_deployable(1) and new_data.unlocked and not new_data.equipped then
			table.insert(new_data, "lo_d_equip_secondary")
		end
		if new_data.equipped then
			table.insert(new_data, "lo_d_unequip")
		end
		data[i] = new_data
		index = i
	end
	for i = 1, max_items do
		if not data[i] then
			new_data = {}
			new_data.name = "empty"
			new_data.name_localized = ""
			new_data.category = "deployables"
			new_data.slot = i
			new_data.unlocked = true
			new_data.equipped = false
			data[i] = new_data
		end
	end
end