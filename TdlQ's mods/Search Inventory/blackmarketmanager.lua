local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

_G.SearchInventory = _G.SearchInventory or {}
SearchInventory._path = ModPath
SearchInventory.filters = {}

function SearchInventory:reset_filters()
	self.filters = {}
end

function SearchInventory:set_filters(str)
	if type(str) == 'string' then
		self.filters = str:split(' ')
	end
end

function SearchInventory:get_filter_str()
	return table.concat(self.filters, ' ')
end

function BlackMarketManager:si_get_search_string_weapons(slot_item, category)
	local data = slot_item._data
	local slot = slot_item.si_index
	local list = self._global.crafted_items[category]

	local item = slot and list[slot]
	if not item then
		return
	end

	local txts = {}

	local dlc_id = data.global_value
	if dlc_id then
		txts[dlc_id] = dlc_id
		local tmp = utf8.to_lower(managers.localization:text(tweak_data.lootdrop.global_values[dlc_id].name_id))
		txts[tmp] = tmp
	end

	if item.custom_name then
		tmp = utf8.to_lower(item.custom_name)
		txts[tmp] = tmp
	end

	local td_weapon = tweak_data.weapon[item.weapon_id]
	local name = utf8.to_lower(managers.localization:text(td_weapon.name_id))
	txts[name]= name
	for _, ctg in pairs(td_weapon.categories) do
		txts[ctg]= ctg
		if managers.localization:exists('menu_' .. ctg) then
			local ctg_txt = utf8.to_lower(managers.localization:text('menu_' .. ctg))
			txts[ctg_txt]= ctg_txt
		end
	end

	local td_factory = tweak_data.weapon.factory
	for _, part_name in ipairs(item.blueprint) do
		local name_id = td_factory.parts[part_name].name_id
		if name_id and managers.localization:exists(name_id) then
			local text = utf8.to_lower(managers.localization:text(name_id))
			txts[text] = text
		end
	end

	local result = ''
	for text in pairs(txts) do
		result = result .. ' ' .. text
	end

	return result
end

function BlackMarketManager:si_get_search_string_melee(slot_item)
	local data = slot_item._data
	local list = self._global.melee_weapons

	local item = list[data.name]
	if not item then
		return
	end

	local txts = {}
	txts[1] = data.name
	txts[2] = utf8.to_lower(data.name_localized)

	local dlc_id = data.global_value
	if dlc_id then
		txts[3] = dlc_id
		txts[4] = utf8.to_lower(managers.localization:text(tweak_data.lootdrop.global_values[dlc_id].name_id))
	end

	return table.concat(txts, ' ')
end

function BlackMarketManager:si_get_search_string_masks(slot_item)
	local slot = slot_item.si_index
	local list = self._global.crafted_items.masks

	local item = slot and list[slot]
	if not item then
		return
	end

	local txts = {}
	txts[1] = utf8.to_lower(item.custom_name or '')

	txts[2] = tostring(item.mask_id)
	txts[3] = utf8.to_lower(managers.localization:text(tweak_data.blackmarket.masks[item.mask_id].name_id))
	txts[4] = utf8.to_lower(managers.localization:text(tweak_data.blackmarket.colors[item.blueprint.color.id].name_id))

	txts[5] = tostring(item.blueprint.material.id)
	txts[6] = tostring(item.blueprint.color.id)
	txts[7] = tostring(item.blueprint.pattern.id)

	local dlc_id = slot_item._data.global_value
	if dlc_id then
		txts[8] = dlc_id
		txts[9] = utf8.to_lower(managers.localization:text(tweak_data.lootdrop.global_values[dlc_id].name_id))
	end

	return table.concat(txts, ' ')
end

function BlackMarketManager:si_get_search_string_tweakblack(slot_item, category)
	local data = slot_item._data
	local list = tweak_data.blackmarket[category]

	local item = list[slot_item._name]
	if not item then
		return
	end

	local txts = {}
	txts[1] = data.name
	txts[2] = utf8.to_lower(data.name_localized)

	local dlc_id = item.dlc
	if dlc_id then
		txts[3] = dlc_id
		txts[4] = utf8.to_lower(managers.localization:text(tweak_data.lootdrop.global_values[dlc_id].name_id))
	end

	return table.concat(txts, ' ')
end

function BlackMarketManager:si_get_search_string(slot_item)
	local category = slot_item._data.category
	if category == 'primaries' or category == 'secondaries' then 
		return self:si_get_search_string_weapons(slot_item, category)
	elseif category == 'melee_weapons' then
		return self:si_get_search_string_melee(slot_item)
	elseif category == 'masks' then
		return self:si_get_search_string_masks(slot_item)
	elseif category == 'materials' or category == 'textures' or category == 'colors' then
		return self:si_get_search_string_tweakblack(slot_item, category)
	end
end
