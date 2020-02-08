local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local lpi_original_hudstatsscreen_recreateright = HUDStatsScreen.recreate_right
function HUDStatsScreen:recreate_right()
	lpi_original_hudstatsscreen_recreateright(self)

	if LobbyPlayerInfo.settings.show_skills_in_stats_screen then
		local right_panel = self._right
		if not right_panel then
			return
		end

		local r = right_panel:w() - 20
		local placer = UiPlacer:new(10, 350)

		for i = 1, 4 do
			local peer = managers.network:session() and managers.network:session():peer(i)
			placer:add_row(self._right:fine_text({
				name = 'lpi_team_text_name' .. tostring(i),
				align = 'left',
				vertical = 'top',
				blend_mode = 'add',
				font_size = tweak_data.menu.pd2_small_font_size,
				font = tweak_data.menu.pd2_small_font,
				color = tweak_data.chat_colors[i],
				text = peer and peer:name() or '',
			}), 0, 15)

			local ping_txt = ''
			if peer then
				local ping = math.ceil(peer:qos().ping)
				if ping > 0 then
					ping_txt = ping .. ' ms'
				end
			end
			local text_ping = self._right:fine_text({
				name = 'lpi_team_text_ping' .. tostring(i),
				align = 'right',
				vertical = 'top',
				blend_mode = 'add',
				font_size = tweak_data.menu.pd2_small_font_size,
				font = tweak_data.menu.pd2_small_font,
				color = tweak_data.screen_colors.text,
				text = ping_txt,
			})
			placer:add_right(text_ping)
			text_ping:set_right(r)

			local outfit = peer and peer:blackmarket_outfit()
			local skills = outfit and outfit.skills
			local perk = skills and skills.specializations

			local skills_txt = ''
			skills = skills and skills.skills
			if skills and #skills >= 15 then
				local ini_len = LobbyPlayerInfo._abbreviation_length_v
				skills_txt = string.format(LobbyPlayerInfo.skills_layouts[#LobbyPlayerInfo.skills_layouts],
					utf8.sub(managers.localization:text('st_menu_mastermind'),  1, ini_len), skills[1],  skills[2],  skills[3],
					utf8.sub(managers.localization:text('st_menu_enforcer'),    1, ini_len), skills[4],  skills[5],  skills[6],
					utf8.sub(managers.localization:text('st_menu_technician'),  1, ini_len), skills[7],  skills[8],  skills[9],
					utf8.sub(managers.localization:text('st_menu_ghost'),       1, ini_len), skills[10], skills[11], skills[12],
					utf8.sub(managers.localization:text('st_menu_hoxton_pack'), 1, ini_len), skills[13], skills[14], skills[15]
				)
			end
			placer:add_row(self._right:fine_text({
				name = 'lpi_team_text_skills' .. tostring(i),
				align = 'left',
				vertical = 'top',
				blend_mode = 'add',
				font_size = tweak_data.menu.pd2_small_font_size - 4,
				font = tweak_data.menu.pd2_small_font,
				color = tweak_data.screen_colors.text,
				text = skills_txt,
			}))

			local perk_txt = ''
			if perk then
				if #perk == 2 then
					perk_txt = LobbyPlayerInfo:GetPerkText(perk[1])
					if tonumber(perk[2]) < 9 then
						perk_txt = perk_txt .. ' (' .. perk[2] .. '/9)'
					end
				else
					perk_txt = 'Unknown perk'
				end
			end
			placer:add_row(self._right:fine_text({
				name = 'lpi_team_text_perk' .. tostring(i),
				align = 'left',
				vertical = 'top',
				blend_mode = 'add',
				font_size = tweak_data.menu.pd2_small_font_size - 4,
				font = tweak_data.menu.pd2_small_font,
				color = tweak_data.screen_colors.text,
				text = perk_txt,
			}))

			local ploss_txt = ''
			if peer then
				local loss_nr = peer:qos().packet_loss
				if loss_nr > 0 then
					ploss_txt = managers.localization:text('lpi_packet_loss') .. ' (' .. loss_nr .. ')'
				elseif NoMA then
					ploss_txt = NoMA:GetTextInfo(i)
				end
			end
			local text_ploss = self._right:fine_text({
				name = 'lpi_team_text_ploss' .. tostring(i),
				text = ploss_txt,
				align = 'right',
				vertical = 'top',
				blend_mode = 'add',
				font_size = tweak_data.menu.pd2_small_font_size - 4,
				font = tweak_data.menu.pd2_small_font,
				color = tweak_data.chat_colors[i],
			})
			placer:add_right(text_ploss)
			text_ploss:set_width(180)
			text_ploss:set_right(r)
		end
	end
end
