_G.LPITeamBox = _G.LPITeamBox or {
	_skills = {}
}

function LPITeamBox:RebuildData(skills)
	local icons = { {}, {}, {}, {}, {} }
	local stars = { {0,0,0}, {0,0,0}, {0,0,0}, {0,0,0}, {0,0,0} }

	skills = skills or self._skills
	for peer_id, skill_text in pairs(skills or {}) do
		local skill_split = string.split(skill_text, '_')

		for tree, points in pairs(skill_split) do
			local bt = math.floor((tree - 1) / 3) + 1
			points = tonumber(points)
			if bt > 5 then
				break
			elseif points == 46 then
				table.insert(icons[bt], {tree = tree, color_idx = 1})
			elseif points > 27 then
				table.insert(icons[bt], {tree = tree, color_idx = 2})
			elseif points > 19 then
				table.insert(icons[bt], {tree = tree, color_idx = 3})
			end
		end
		for i = 1, 5 do
			table.sort(icons[i], function(a, b)
					if a.color_idx ~= b.color_idx then
						return a.color_idx < b.color_idx
					else
						return a.tree < b.tree
					end
				end)
		end

		local ppt = LobbyPlayerInfo:GetSkillPointsPerTree(skill_split)
		for i = 1, 5 do
			local n = tonumber(ppt[i])
			if n > LobbyPlayerInfo.settings.team_skillpoints_thresholds.overspecialized then
				stars[i][1] = stars[i][1] + 1
			elseif n > LobbyPlayerInfo.settings.team_skillpoints_thresholds.gold then
				stars[i][2] = stars[i][2] + 1
			elseif n > LobbyPlayerInfo.settings.team_skillpoints_thresholds.silver then
				stars[i][3] = stars[i][3] + 1
			end
		end
	end

	self._team_icons = icons
	self._team_stars = stars
end

function LPITeamBox:Update()
	if alive(self._team_skills_panel) then
		self._team_skills_panel:clear()
		self.contractboxgui._panel:remove(self._team_skills_panel)
		self._team_skills_panel = nil
	end

	local crowd = 0
	if LobbyPlayerInfo.settings.team_skills_mode == 4 then
		for _, icons in pairs(self._team_icons) do
			crowd = math.max(crowd, #icons)
		end
	elseif LobbyPlayerInfo.settings.team_skills_mode == 3 then
		for _, icons in pairs(self._team_icons) do
			local v = 0
			for _, icon in pairs(icons) do
				if icon.color_idx < 3 then
					v = v + 1
				end
			end
			crowd = math.max(crowd, v)
		end
	end

	-- Box
	local container, y, w
	if self.contractboxgui._contract_panel then
		container = self.contractboxgui._panel
		local obj = self.contractboxgui._contract_text_header or self.contractboxgui._contract_panel
		y = obj:top() - 5
		w = self.contractboxgui._contract_panel:w() * (crowd > 8 and 0.7 or 0.5)
	else
		container = self.contractboxgui._parent
		local missions_gui = managers.menu_component and managers.menu_component:crime_spree_missions_gui()
		y = missions_gui and missions_gui._buttons_panel and missions_gui._buttons_panel:top() - 30
		w = (crowd > 8 and 294 or 210)
	end
	self._team_skills_panel = container:panel({
		name = 'team_skills_panel',
		w = w,
		h = 100,
		layer = -1
	})
	self._team_skills_panel:rect({
		color = Color(0.5, 0, 0, 0),
		layer = -2,
		halign = 'grow',
		valign = 'grow'
	})
	self._team_skills_panel:set_rightbottom(container:w(), y)
	BoxGuiObject:new(self._team_skills_panel, { sides = {1, 1, 1, 1} } )
	self._team_skills_panel:set_visible(LobbyPlayerInfo.settings.team_skills_mode > 1)

	-- Title
	if not self._team_skills_text or tostring(self._team_skills_text) == '[Text NULL]' then
		self._team_skills_text = container:text({
			name = 'lpi_team_skills_text',
			text = managers.localization:to_upper_text('lpi_team_skills'),
			font_size = tweak_data.menu.pd2_small_font_size,
			font = tweak_data.menu.pd2_medium_font,
			color = tweak_data.screen_colors.text,
			blend_mode = 'add',
		})
		local _, _, tw, th = self._team_skills_text:text_rect()
		self._team_skills_text:set_size(tw, th)
		self._team_skills_text:set_bottom(self._team_skills_panel:top())
		self._team_skills_text:set_left(self._team_skills_panel:left())
	end
	self._team_skills_text:set_visible(LobbyPlayerInfo.settings.team_skills_mode > 1)

	-- Trees
	local bmp = nil
	local txt = managers.localization:text('st_menu_mastermind') .. ':\n'
		.. managers.localization:text('st_menu_enforcer') .. ':\n'
		.. managers.localization:text('st_menu_technician') .. ':\n'
		.. managers.localization:text('st_menu_ghost') .. ':\n'
		.. managers.localization:text('st_menu_hoxton_pack') .. ':'
	if crowd > 4 then
		txt = ':\n:\n:\n:\n:'
		for i = 1, 5 do
			bmp = self._team_skills_panel:bitmap({
				texture = 'guis/textures/pd2/inv_skillcards_icons',
				texture_rect = {(i - 1) * 24 + 1, 0, 20, 30},
				color = Color('ababab'),
				blend_mode = 'add',
				layer = -1,
				w = 10,
				h = 15
			})
			bmp:set_left(9)
			bmp:set_top(9 + (i - 1) * 17)
		end
	end
	self._ts_trees_text = self._team_skills_panel:text({
		layer = -1,
		text = txt,
		align = 'right',
		font_size = tweak_data.menu.pd2_small_font_size - 4,
		font = tweak_data.menu.pd2_small_font,
		color = Color('ababab'),
		blend_mode = 'add',
	})
	local _, _, tw, th = self._ts_trees_text:text_rect()
	self._ts_trees_text:set_size(tw, th)
	if crowd > 4 then
		self._ts_trees_text:set_left(bmp:right() + 4)
	else
		self._ts_trees_text:set_right(self._team_skills_panel:w() / 2)
	end
	self._ts_trees_text:set_center_y(self._team_skills_panel:h() / 2)

	-- Stars
	if LobbyPlayerInfo.settings.team_skills_mode == 2 and self._team_stars then
		local colors = { Color('e60000'), Color('ffd300'), Color('a0a0a0') }
		for line = 1, #self._team_stars do
			local nth = 0
			for i = 1, 3 do
				for j = 1, self._team_stars[line][i] do
					self:CreateTeamStar(line, nth, colors[i])
					nth = nth + 1
				end
			end
		end
	end

	-- Icons
	if LobbyPlayerInfo.settings.team_skills_mode > 2 and self._team_icons then
		local colors = { Color('e60000'), Color('ffd300'), Color('a0a0a0') }
		for line, icons in ipairs(self._team_icons) do
			local nth = 0
			for _, icon in pairs(icons) do
				if not (LobbyPlayerInfo.settings.team_skills_mode == 3 and icon.color_idx == 3) then
					self:CreateTeamSkillIcon(line, nth, colors[icon.color_idx], icon.tree)
					nth = nth + 1
				end
			end
		end
	end
end

function LPITeamBox:CreateTeamStar(line, nth, color)
	local bmp = self._team_skills_panel:bitmap({
		layer = -1,
		color = color,
		blend_mode = 'normal',
		texture = 'guis/textures/pd2/crimenet_star',
	})
	bmp:set_left(self._ts_trees_text:right() + 4 + bmp:texture_width() * nth)
	local lh = self._ts_trees_text:h() / 5
	bmp:set_top(self._ts_trees_text:top() + ((line - 1) * lh) + ((lh - bmp:texture_height()) / 2))
end

function LPITeamBox:CreateTeamSkillIcon(line, nth, color, tree_id)
	local skill_name = tweak_data.skilltree.trees[tree_id].tiers[4][1]
	local skill_data = tweak_data.skilltree.skills[skill_name]
	local texture_rect_x = skill_data.icon_xy and skill_data.icon_xy[1] or 0
	local texture_rect_y = skill_data.icon_xy and skill_data.icon_xy[2] or 0
	local texture_width = 20
	local texture_height = 20
	local bmp = self._team_skills_panel:bitmap({
		texture = 'guis/textures/pd2/skilltree_2/icons_atlas_2',
		texture_rect = {
			texture_rect_x * 80,
			texture_rect_y * 80,
			80,
			80
		},
		color = color,
		blend_mode = 'add',
		layer = -1,
		w = texture_width,
		h = texture_height
	})
	bmp:set_left(self._ts_trees_text:right() + 4 + texture_width * nth)
	local lh = self._ts_trees_text:h() / 5
	bmp:set_top(self._ts_trees_text:top() + ((line - 1) * lh) + ((lh - texture_height) / 2))
end
