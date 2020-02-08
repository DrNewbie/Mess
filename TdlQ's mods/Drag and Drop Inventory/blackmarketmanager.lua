local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local ddi_original_blackmarketmanager_load = BlackMarketManager.load
function BlackMarketManager:load(...)
	ddi_original_blackmarketmanager_load(self, ...)

	local masks = self._global and self._global.crafted_items and self._global.crafted_items.masks
	if masks and (not masks[1] or masks[1].mask_id ~= 'character_locked') then
		masks[1] = {
			mask_id = 'character_locked',
			modded = false,
			global_value = 'normal',
			blueprint = {
				material = {
					global_value = 'normal',
					id = 'plastic'
				},
					color = {
					global_value = 'normal',
					id = 'nothing'
				},
				pattern = {
					global_value = 'normal',
					id = 'no_color_no_material'
				}
			}
		}
	end
end

local ddi_original_blackmarketmanager_placecrafteditem = BlackMarketManager.place_crafted_item
function BlackMarketManager:place_crafted_item(category, slot)
	local from_slot = self._hold_crafted_item and self._hold_crafted_item.category == category and self._hold_crafted_item.slot

	ddi_original_blackmarketmanager_placecrafteditem(self, category, slot)

	if from_slot then
		managers.multi_profile:ddi_swap_item(category, from_slot, slot)
	end
end

function BlackMarketManager:ddi_move_page(category, page_from, page_to)
	if page_from == page_to then
		return
	end

	local crafted_items = self._global.crafted_items[category]
	local old_crafted_items = clone(crafted_items)

	local tg = tweak_data.gui
	local nr, qty, unlocked_slots
	if category == 'masks' then
		qty = tg.MASK_ROWS_PER_PAGE * tg.MASK_COLUMNS_PER_PAGE
		nr = qty * tg.MAX_MASK_PAGES
		unlocked_slots = self._global.unlocked_mask_slots
	else
		qty = tg.WEAPON_ROWS_PER_PAGE * tg.WEAPON_COLUMNS_PER_PAGE
		nr = qty * tg.MAX_WEAPON_PAGES
		unlocked_slots = self._global.unlocked_weapon_slots[category]
	end

	local src_index = 1 + (page_from - 1) * qty
	local dst_index = 1 + (page_to - 1) * qty

	for _, items in ipairs({crafted_items, unlocked_slots}) do
		for i = 1, nr do
			if items[i] == nil then
				items[i] = 'nil'
			end
		end

		local tmp = {}
		for i = 1, qty do
			tmp[i] = table.remove(items, src_index)
		end
		for i = qty, 1, -1 do
			table.insert(items, dst_index, tmp[i])
		end

		for i = 1, nr do
			if items[i] == 'nil' then
				items[i] = nil
			end
		end
	end

	managers.multi_profile:ddi_update_other_profiles(category, old_crafted_items, crafted_items)
end
