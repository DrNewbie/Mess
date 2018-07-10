local AssetsPath = ModPath.."/Assets/"

function HUDTeammate:_create_radial_health(radial_health_panel)
	self._radial_health_panel = radial_health_panel
	local radial_size = self._main_player and 64 or 48
	local radial_bg = radial_health_panel:bitmap({
		texture = "guis/textures/pd2/hud_radialbg",
		name = "radial_bg",
		alpha = 1,
		layer = 0,
		w = radial_health_panel:w(),
		h = radial_health_panel:h()
	})
	local radial_health
	if self._main_player then
		radial_health = radial_health_panel:bitmap({
		texture = "guis/textures/pd2/hud_health_alt",
		name = "radial_health",
		layer = 2,
		blend_mode = "add",
		render_template = "VertexColorTexturedRadial",
		texture_rect = {
			128,
			0,
			-128,
			128
		},
		color = Color(1, 0, 1, 1),
		w = radial_health_panel:w(),
		h = radial_health_panel:h()
		})
	else
		radial_health = radial_health_panel:bitmap({
		texture = "guis/textures/pd2/hud_health",
		name = "radial_health",
		layer = 2,
		blend_mode = "add",
		render_template = "VertexColorTexturedRadial",
		texture_rect = {
			128,
			0,
			-128,
			128
		},
		color = Color(1, 0, 1, 1),
		w = radial_health_panel:w(),
		h = radial_health_panel:h()
		})
	end
	local radial_shield = radial_health_panel:bitmap({
		texture = "guis/textures/pd2/hud_shield",
		name = "radial_shield",
		layer = 1,
		blend_mode = "add",
		render_template = "VertexColorTexturedRadial",
		texture_rect = {
			128,
			0,
			-128,
			128
		},
		color = Color(1, 0, 1, 1),
		w = radial_health_panel:w(),
		h = radial_health_panel:h()
	})
	local damage_indicator = radial_health_panel:bitmap({
		blend_mode = "add",
		name = "damage_indicator",
		alpha = 0,
		texture = "guis/textures/pd2/hud_radial_rim",
		layer = 1,
		color = Color(1, 1, 1, 1),
		w = radial_health_panel:w(),
		h = radial_health_panel:h()
	})
	local radial_custom = radial_health_panel:bitmap({
		texture = "guis/textures/pd2/hud_swansong",
		name = "radial_custom",
		blend_mode = "add",
		visible = false,
		render_template = "VertexColorTexturedRadial",
		layer = 5,
		color = Color(1, 0, 0, 0),
		w = radial_health_panel:w(),
		h = radial_health_panel:h()
	})
	local radial_ability_panel = radial_health_panel:panel({
		visible = false,
		name = "radial_ability"
	})
	local radial_ability_meter = radial_ability_panel:bitmap({
		blend_mode = "add",
		name = "ability_meter",
		texture = "guis/textures/pd2/hud_fearless",
		render_template = "VertexColorTexturedRadial",
		layer = 5,
		color = Color(1, 0, 0, 0),
		w = radial_health_panel:w(),
		h = radial_health_panel:h()
	})
	local radial_ability_icon = radial_ability_panel:bitmap({
		blend_mode = "add",
		name = "ability_icon",
		alpha = 1,
		layer = 5,
		w = radial_size * 0.5,
		h = radial_size * 0.5
	})

	radial_ability_icon:set_center(radial_ability_panel:center())

	local radial_delayed_damage_panel = radial_health_panel:panel({name = "radial_delayed_damage"})
	local radial_delayed_damage_armor = radial_delayed_damage_panel:bitmap({
		texture = "guis/textures/pd2/hud_dot_shield",
		name = "radial_delayed_damage_armor",
		visible = false,
		render_template = "VertexColorTexturedRadialFlex",
		layer = 5,
		w = radial_delayed_damage_panel:w(),
		h = radial_delayed_damage_panel:h()
	})
	local radial_delayed_damage_health = radial_delayed_damage_panel:bitmap({
		texture = "guis/textures/pd2/hud_dot",
		name = "radial_delayed_damage_health",
		visible = false,
		render_template = "VertexColorTexturedRadialFlex",
		layer = 5,
		w = radial_delayed_damage_panel:w(),
		h = radial_delayed_damage_panel:h()
	})

	if self._main_player then
		local radial_rip = radial_health_panel:bitmap({
			texture = "guis/textures/pd2/hud_rip",
			name = "radial_rip",
			layer = 3,
			blend_mode = "add",
			visible = false,
			render_template = "VertexColorTexturedRadial",
			texture_rect = {
				128,
				0,
				-128,
				128
			},
			color = Color(1, 0, 0, 0),
			w = radial_health_panel:w(),
			h = radial_health_panel:h()
		})
		local radial_rip_bg = radial_health_panel:bitmap({
			texture = "guis/textures/pd2/hud_rip_bg",
			name = "radial_rip_bg",
			layer = 1,
			visible = false,
			render_template = "VertexColorTexturedRadial",
			texture_rect = {
				128,
				0,
				-128,
				128
			},
			color = Color(1, 0, 0, 0),
			w = radial_health_panel:w(),
			h = radial_health_panel:h()
		})
	end

	radial_health_panel:bitmap({
		texture = "guis/dlcs/coco/textures/pd2/hud_absorb_shield",
		name = "radial_absorb_shield_active",
		visible = false,
		render_template = "VertexColorTexturedRadial",
		layer = 5,
		color = Color(1, 0, 0, 0),
		w = radial_health_panel:w(),
		h = radial_health_panel:h()
	})

	local radial_absorb_health_active = radial_health_panel:bitmap({
		texture = "guis/dlcs/coco/textures/pd2/hud_absorb_health",
		name = "radial_absorb_health_active",
		visible = false,
		render_template = "VertexColorTexturedRadial",
		layer = 5,
		color = Color(1, 0, 0, 0),
		w = radial_health_panel:w(),
		h = radial_health_panel:h()
	})

	radial_absorb_health_active:animate(callback(self, self, "animate_update_absorb_active"))
	radial_health_panel:bitmap({
		texture = "guis/dlcs/coco/textures/pd2/hud_absorb_stack_fg",
		name = "radial_info_meter",
		blend_mode = "add",
		visible = false,
		render_template = "VertexColorTexturedRadial",
		layer = 3,
		color = Color(1, 0, 0, 0),
		w = radial_health_panel:w(),
		h = radial_health_panel:h()
	})
	radial_health_panel:bitmap({
		texture = "guis/dlcs/coco/textures/pd2/hud_absorb_stack_bg",
		name = "radial_info_meter_bg",
		layer = 1,
		visible = false,
		render_template = "VertexColorTexturedRadial",
		texture_rect = {
			128,
			0,
			-128,
			128
		},
		color = Color(1, 0, 0, 0),
		w = radial_health_panel:w(),
		h = radial_health_panel:h()
	})
	self:_create_condition(radial_health_panel)
end

Hooks:PostHook(HUDTeammate, 'set_health', 'Post_set_health_chanage_colour', function(self, data)
	if self._main_player and data.current and data.total then
		local ratio = data.current / data.total
		if ratio > 0.90 then
			CustomPackageManager:LoadPackageConfig(AssetsPath.."100", {{
				_meta = "texture",
				path = "guis/textures/pd2/hud_health_alt",
				force = true
			}})
		elseif 0.90 >= ratio and ratio > 0.75 then
			CustomPackageManager:LoadPackageConfig(AssetsPath.."90", {{
				_meta = "texture",
				path = "guis/textures/pd2/hud_health_alt",
				force = true
			}})
		elseif 0.75 >= ratio and ratio > 0.50 then
			CustomPackageManager:LoadPackageConfig(AssetsPath.."75", {{
				_meta = "texture",
				path = "guis/textures/pd2/hud_health_alt",
				force = true
			}})
		elseif 0.50 >= ratio and ratio > 0.25 then
			CustomPackageManager:LoadPackageConfig(AssetsPath.."50", {{
				_meta = "texture",
				path = "guis/textures/pd2/hud_health_alt",
				force = true
			}})
		elseif 0.25 >= ratio then
			CustomPackageManager:LoadPackageConfig(AssetsPath.."25", {{
				_meta = "texture",
				path = "guis/textures/pd2/hud_health_alt",
				force = true
			}})
		end
	end
end)