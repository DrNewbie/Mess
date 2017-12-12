local CriticalPerkDeckIconInit = SpecializationTierItem.init

function SpecializationTierItem:custom_tier_icon(guis_catalog, tier_data, texture)
	if texture then
		return {
			layer = 1,
			halign = "scale",
			valign = "scale",
			blend_mode = "add",
			name = tostring(math.random(1000000)),
			texture = texture,
			texture_rect = {
				tier_data.icon_xy and tier_data.icon_xy[1] or 0,
				tier_data.icon_xy and tier_data.icon_xy[2] or 0,
				tier_data.icon_xy and tier_data.icon_xy[3] or 64,
				tier_data.icon_xy and tier_data.icon_xy[4] or 64
			},
			color = Color.white
		}
	else
		local icon_atlas_texture = guis_catalog .. "textures/pd2/specialization/icons_atlas"
		return {
			layer = 1,
			halign = "scale",
			valign = "scale",
			blend_mode = "add",
			name = tostring(math.random(1000000)),
			texture = icon_atlas_texture,
			texture_rect = {
				tier_data.icon_xy and tier_data.icon_xy[1] or 0,
				tier_data.icon_xy and tier_data.icon_xy[2] or 0,
				64,
				64
			},
			color = Color.white
		}
	end
end

function SpecializationTierItem:custom_init(tier_data, tree_panel, tree, tier, x, y, w, h)
	SpecializationTierItem.super.init(self)
	self._locked = false
	self._tree = tree
	self._tier = tier
	local specialization_descs = tweak_data.upgrades.specialization_descs[tree]
	specialization_descs = specialization_descs and specialization_descs[tier] or {}
	local macroes = {}
	for i, d in pairs(specialization_descs) do
		macroes[i] = d
	end
	self._tier_data = tier_data
	self._name_string = tier_data.name_id and managers.localization:text(tier_data.name_id) or "NO_NAME_" .. tostring(tree) .. "_" .. tostring(tier)
	self._desc_string = tier_data.desc_id and managers.localization:text(tier_data.desc_id, macroes) or "NO_DESC_" .. tostring(tree) .. "_" .. tostring(tier)
	local tier_panel = tree_panel:panel({
		halign = "scale",
		valign = "scale",
		name = tostring(tier),
		x = x,
		y = y,
		w = w,
		h = h
	})
	self._tier_panel = tier_panel
	self._basic_size = {
		w - 32,
		h - 32
	}
	self._selected_size = {
		w,
		h
	}
	local texture_rect = {
		0,
		0,
		64,
		92
	}
	local unlocked_bg = tier_panel:bitmap({
		name = "unlocked_bg",
		layer = 0,
		visible = false,
		valign = "scale",
		halign = "scale",
		texture = "guis/textures/pd2/specialization/perk_icon_card",
		texture_rect = texture_rect,
		color = Color.white
	})
	unlocked_bg:set_center(tier_panel:w() / 2, tier_panel:h() / 2)
	local texture_rect_x = tier_data.icon_xy and tier_data.icon_xy[1] or 0
	local texture_rect_y = tier_data.icon_xy and tier_data.icon_xy[2] or 0
	local guis_catalog = "guis/"
	if tier_data.texture_bundle_folder then
		guis_catalog = guis_catalog .. "dlcs/" .. tostring(tier_data.texture_bundle_folder) .. "/"
	end
	local tier_icon = tier_panel:bitmap(self:custom_tier_icon(guis_catalog, tier_data.icon_xy, tier_data.texture or nil))
	tier_icon:grow(tier_data.grow and tier_data.grow[1] or -16, tier_data.grow and tier_data.grow[2] or -16)
	tier_icon:set_center(tier_panel:w() / 2 + (tier_data.cw_fix and tier_data.cw_fix*tier_panel:w() or 0), (tier_panel:h() / 2) + (tier_data.ch_fix and tier_data.ch_fix*tier_panel:h() or 0))
	self._tier_icon = tier_icon
	local progress_circle = tier_panel:bitmap({
		texture = "guis/textures/pd2/specialization/progress_ring",
		name = "progress_circle_current",
		valign = "scale",
		visible = false,
		alpha = 0.5,
		halign = "scale",
		render_template = "VertexColorTexturedRadial",
		layer = 1,
		color = Color(0, 1, 1)
	})
	progress_circle:set_shape(-6, -6, w + 12, h + 12)
	progress_circle:set_blend_mode("add")
	local progress_circle = tier_panel:bitmap({
		texture = "guis/textures/pd2/specialization/progress_ring",
		name = "progress_circle",
		valign = "scale",
		visible = false,
		alpha = 0.5,
		halign = "scale",
		render_template = "VertexColorTexturedRadial",
		layer = 1,
		color = Color(0, 1, 1)
	})
	progress_circle:set_shape(-6, -6, w + 12, h + 12)
	progress_circle:set_blend_mode("add")
	local progress_circle_bg = tier_panel:bitmap({
		texture = "guis/textures/pd2/specialization/progress_ring",
		name = "progress_circle_bg",
		valign = "scale",
		visible = false,
		halign = "scale",
		alpha = 0.1,
		layer = 0,
		color = Color.white
	})
	progress_circle_bg:set_shape(-6, -6, w + 12, h + 12)
	self._select_box_panel = self._tier_panel:panel({})
	self._inside_panel = self._select_box_panel:panel({})
	self._inside_panel:set_shape(6, 6, w - 12, h - 12)
	self._select_box = BoxGuiObject:new(self._select_box_panel, {sides = {
		1,
		1,
		1,
		1
	}})
	self._select_box:hide()
	self._select_box:set_clipping(false)
	self:refresh()
end

function SpecializationTierItem:init(tier_data, tree_panel, tree, tier, x, y, w, h)
	local tree_tweak = tweak_data.skilltree.specializations[tree]
	if tree_tweak.custom and tree_tweak[tier] and tree_tweak[tier].custom then
		self._tree_name = tree_tweak.custom_id
		self:custom_init(tier_data, tree_panel, tree, tier, x, y, w, h)
		return
	end
	CriticalPerkDeckIconInit(self, tier_data, tree_panel, tree, tier, x, y, w, h)
end