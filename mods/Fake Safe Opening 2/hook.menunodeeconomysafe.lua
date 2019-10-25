_G.FakeOpenSafeF = _G.FakeOpenSafeF or {}

local _old_create_raffle_panel = MenuNodeEconomySafe._create_raffle_panel

Hooks:PreHook(MenuNodeEconomySafe, "init", "FakeOpenSafeFMenuNodeInit", function(self, node)
	if managers.menu_scene._fake_safe_ids then
		node:parameters().safe_entry = "fake_safe_1"
	end
end)

function MenuNodeEconomySafe:_create_raffle_panel(x, data, index, ...)
	if not managers.menu_scene._fake_safe_ids then
		return _old_create_raffle_panel(self, x, data, index, ...)
	end
	local p = self._raffle_panel:panel({
		h = 108,
		y = 24,
		x = x,
		w = self._raffle_panel_width
	})
	local image_panel = p:panel({
		x = 0,
		y = 0,
		w = p:w(),
		h = p:h() - 24
	})

	image_panel:bitmap({
		texture = "guis/dlcs/cash/textures/pd2/safe_raffle/bg_black",
		name = "bg_black",
		layer = -1,
		w = image_panel:w(),
		h = image_panel:h()
	})

	index = index or #self._raffle_panels + 1

	table.insert(self._raffle_panels, index, p)

	local texture_name = nil
	local name_id = "bm_none"
	local rarity_color = Color.white
	local texture_rarity_name = "guis/dlcs/cash/textures/pd2/safe_raffle/header_col_common"
	local is_legendary = false
	local bonuses = nil

	if tweak_data.blackmarket[data.category] then
		local entry_data = tweak_data.blackmarket[data.category][data.entry]
		local weapon_id = entry_data.weapon_id or entry_data.weapons[1]
		is_legendary = entry_data.rarity == "legendary"
		texture_name = is_legendary and "guis/dlcs/cash/textures/pd2/safe_raffle/icon_legendary" or managers.blackmarket:get_weapon_icon_path(weapon_id, {
			id = data.entry
		})
		name_id = entry_data.name_id
		rarity_color = tweak_data.economy.rarities[entry_data.rarity].color
		texture_rarity_name = tweak_data.economy.rarities[entry_data.rarity].header_col

		if data.bonus and entry_data.bonus then
			bonuses = tweak_data.economy:get_bonus_icons(entry_data.bonus)
		end
	elseif tweak_data.economy[data.category] then
		local entry_data = tweak_data.economy[data.category][data.entry]
		name_id = entry_data.name_id
		texture_name = "guis/dlcs/cash/textures/pd2/safe_raffle/icon_legendary"
		rarity_color = tweak_data.economy.rarities[entry_data.rarity].color
		texture_rarity_name = tweak_data.economy.rarities[entry_data.rarity].header_col
	end
	
	texture_name = "guis/dlcs/cash/textures/pd2/safe_raffle/icon_legendary"

	local name = managers.localization:text(name_id)

	if is_legendary then
		name = managers.localization:text("bm_menu_rarity_legendary_item")
	end

	p:text({
		halign = "left",
		vertical = "top",
		name = "number",
		align = "center",
		visible = false,
		layer = 10,
		text = "" .. index,
		font_size = self.font_size,
		font = self.font
	})
	p:bitmap({
		name = "",
		h = 24,
		texture = texture_rarity_name,
		y = p:h() - 24,
		w = p:w()
	})
	p:text({
		halign = "left",
		vertical = "center",
		h = 24,
		name = "name",
		font_size = 20,
		align = "left",
		x = 8,
		layer = 10,
		text = name,
		y = p:h() - 24,
		font = self.font
	})

	if bonuses then
		local x = p:w() - 4

		for _, texture_path in ipairs(bonuses) do
			local bonus_bitmap = p:bitmap({
				name = "bonus",
				h = 16,
				w = 16,
				layer = 1,
				texture = texture_path,
				x = p:w() - 24,
				y = p:h() - 24
			})

			bonus_bitmap:set_right(x)
			bonus_bitmap:set_center_y(p:h() - 12)

			x = bonus_bitmap:left() - 1
		end
	end

	self:request_texture(texture_name, image_panel, true)
end