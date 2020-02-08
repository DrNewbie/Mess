local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

dofile(ModPath .. 'lua/_lpi.lua')
dofile(ModPath .. 'lua/contractboxgui_teambox.lua')

local lpi_original_contractboxgui_init = ContractBoxGui.init
function ContractBoxGui:init(...)
	lpi_original_contractboxgui_init(self, ...)
	LPITeamBox.contractboxgui = self
end

local lpi_original_contractboxgui_update = ContractBoxGui.update
function ContractBoxGui:update(...)
	lpi_original_contractboxgui_update(self, ...)

	if self._skills_changed then
		self._skills_changed = false
		LPITeamBox:RebuildData(self._skills)
		LPITeamBox:Update()
	end
end

local function UpdateAlpha(obj, mode, mouse_over, max_alpha)
	if alive(obj) then
		local ma = max_alpha or 1
		local sa = obj:alpha()
		if mode == 3 or (mode == 2 and mouse_over) then
			sa = math.min(ma, sa + (0.25 * ma))
		else
			sa = math.max( 0, sa - (0.05 * ma))
		end
		obj:set_alpha(sa)
		return sa > 0
	end
end

local lpi_original_contractboxgui_updatecharactermenustate = ContractBoxGui.update_character_menu_state
function ContractBoxGui:update_character_menu_state(peer_id, state)
	lpi_original_contractboxgui_updatecharactermenustate(self, peer_id, state)

	if self._enabled and peer_id == 4 and state == nil then
		if alive(self._contract_panel) then
			self._contract_panel:set_alpha(1)
		end
		if alive(self._contract_text_header) then
			self._contract_text_header:set_alpha(1)
		end
		if alive(self._contract_pro_text) then
			self._contract_pro_text:set_alpha(1)
		end
	end
end

local lpi_original_contractboxgui_createcharactertext = ContractBoxGui.create_character_text
function ContractBoxGui:create_character_text(peer_id, ...)
	lpi_original_contractboxgui_createcharactertext(self, peer_id, ...)

	self._skills = self._skills or {}
	local peer = managers.network:session():peer(peer_id)
	local skills_text, perk_text, perk_prog, sp_anomaly, show_progbar, is_local_peer, skills_string = LobbyPlayerInfo:GetPeerData(peer_id, peer)
	self._skills_changed = self._skills_changed or self._skills[peer_id] ~= skills_string
	self._skills[peer_id] = skills_string
	local visible = not not (self._enabled and peer)
	local steamid = peer and peer:user_id() or ''

	local _, _, w, h = self._peers_state[peer_id]:text_rect()
	self._peers_state[peer_id]:set_size(w, h)

	local mx, my = managers.mouse_pointer:modified_mouse_pos()
	local mouse_over = mx > self._peers[peer_id]:left()
		and mx < self._peers[peer_id]:right()
		and my < self._peers[peer_id]:bottom() + self._peers[peer_id]:height() * 6
		and my > self._peers[peer_id]:top()    - self._peers[peer_id]:height() * 3

	-- Contract box
	if visible and peer_id == 4 then
		if LobbyPlayerInfo.settings.show_skills_mode > 1 then
			UpdateAlpha(self._contract_panel, 2, not mouse_over)
			UpdateAlpha(self._contract_text_header, 2, not mouse_over)
			UpdateAlpha(self._contract_pro_text, 2, not mouse_over)
		end
	end

	-- Specialization
	self._peers_spec = self._peers_spec or {}
	self._peers_spec_bg = self._peers_spec_bg or {}
	self._peers_spec_bg_p = self._peers_spec_bg_p or {}
	if not self._peers_spec[peer_id] then
		self._peers_spec[peer_id], self._peers_spec_bg[peer_id], self._peers_spec_bg_p[peer_id] = LobbyPlayerInfo.CreatePeerSpecialization(self._panel, peer_id)
	end
	LobbyPlayerInfo.RelocateBelow(self._peers_spec[peer_id], self._peers_state[peer_id])
	LobbyPlayerInfo:SetPeerSpecialization(self._peers_spec[peer_id], self._peers_spec_bg[peer_id], self._peers_spec_bg_p[peer_id], peer_id, visible, perk_prog, mouse_over, show_progbar, perk_text)

	-- Skills
	self._peers_skills = self._peers_skills or {}
	local neighbour = LobbyPlayerInfo.settings.show_perkdeck_mode == 1 and self._peers_state[peer_id] or self._peers_spec[peer_id]
	self._peers_skills[peer_id] = self._peers_skills[peer_id] or LobbyPlayerInfo:CreatePeerSkills(self._panel)
	LobbyPlayerInfo:SetPeerSkills(self._peers_skills[peer_id], visible, sp_anomaly, mouse_over, skills_text, skills_string)
	LobbyPlayerInfo.RelocateBelow(self._peers_skills[peer_id], neighbour)

	-- Play time
	self._peers_play_time = self._peers_play_time or {}
	self._peers_play_time[peer_id] = self._peers_play_time[peer_id] or LobbyPlayerInfo:CreatePeerPlaytime(self._panel)
	LobbyPlayerInfo.RelocateAbove(self._peers_play_time[peer_id], self._peers[peer_id])
	LobbyPlayerInfo:SetPeerPlaytime(self._peers_play_time[peer_id], visible, mouse_over, LobbyPlayerInfo.play_times[steamid])

	-- Talkers
	self._peers_talking = self._peers_talking or {}
	self._peers_talking[peer_id] = self._peers_talking[peer_id] or LobbyPlayerInfo.CreatePeerTalking(self._panel)
	LobbyPlayerInfo.RelocateAbove(self._peers_talking[peer_id], self._peers_play_time[peer_id])
	LobbyPlayerInfo.SetPeerTalking(self._peers_talking[peer_id], peer_id, is_local_peer, visible)
end

function LobbyPlayerInfo.RelocateAbove(obj, neighbour)
	obj:set_bottom(neighbour:top())
	obj:set_center_x(neighbour:center_x())
end

function LobbyPlayerInfo.RelocateBelow(obj, neighbour)
	obj:set_top(neighbour:bottom())
	obj:set_center_x(neighbour:center_x())
end

function LobbyPlayerInfo:GetPeerData(peer_id, peer)
	local perk_text = '???'
	local perk_prog = 0
	local show_progbar = false
	local skills_text = ''
	local sp_anomaly = false
	local skills_string
	peer = peer or managers.network:session():peer(peer_id)
	if peer then
		local is_local_peer = peer_id == managers.network:session():local_peer():id()
		if self.settings.show_play_time_mode > 1 then
			local steamid = peer:user_id()
			if steamid and not self.play_times[steamid] then
				if is_local_peer then
					self.play_times[steamid] = ''
				else
					self.play_times[steamid] = '...'
					local apikey = self.settings.steam_apikey
					if type(apikey) == 'string' and apikey:len() == 32 then
						local url = 'http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=' .. apikey .. '&steamid=' .. steamid .. '&format=json'
						dohttpreq(url, callback(LobbyPlayerInfo, LobbyPlayerInfo, 'GetApiPlayTimeCallback', steamid))
					else
						local url = 'http://steamcommunity.com/profiles/' .. steamid .. '/games/?tab=all'
						dohttpreq(url, callback(LobbyPlayerInfo, LobbyPlayerInfo, 'GetPlayTimeCallback', steamid))
					end
				end
			end
		end

		local pskills = peer:skills()
		if pskills then
			local skills_perks = string.split(pskills, '-')
			if #skills_perks == 2 then
				local skillpoints = 0
				skills_string = skills_perks[1]
				local skills = string.split(skills_string, '_')
				if #skills >= 15 then
					local sums = self:GetSkillPointsPerTree(skills)
					local txts = {'', '', '', '', ''}
					if self.settings.skills_layout == 1 or (self.settings.skills_layout == 2 and self.settings.skills_details == 1) then
						for i = 1, 5 do
							txts[i] = string.format('%02u', sums[i])
						end

					elseif self.settings.skills_details == 2 then
						for i = 0, 4 do
							txts[i+1] = string.format('%02u, %02u, %02u', skills[i * 3 + 1], skills[i * 3 + 2], skills[i * 3 + 3])
						end

					elseif self.settings.skills_details == 3 then
						for i = 0, 4 do
							txts[i+1] = string.format('%02u (%02u, %02u, %02u)', sums[i+1], skills[i * 3 + 1], skills[i * 3 + 2], skills[i * 3 + 3])
						end
					end

					local ini_len = self:GetSkillNameLength()
					local ini_mas = utf8.sub(managers.localization:text('st_menu_mastermind'), 1, ini_len)
					local ini_enf = utf8.sub(managers.localization:text('st_menu_enforcer'), 1, ini_len)
					local ini_tec = utf8.sub(managers.localization:text('st_menu_technician'), 1, ini_len)
					local ini_gho = utf8.sub(managers.localization:text('st_menu_ghost'), 1, ini_len)
					local ini_fug = utf8.sub(managers.localization:text('st_menu_hoxton_pack'), 1, ini_len)
					skills_text = string.format(self:GetSkillsFormat(), ini_mas, txts[1], ini_enf, txts[2], ini_tec, txts[3], ini_gho, txts[4], ini_fug, txts[5])

					for i = 1, #skills do
						skillpoints = skillpoints + tonumber(skills[i])
					end
				end

				local perks = string.split(skills_perks[2], '_')
				if #perks == 2 then
					perk_text = LobbyPlayerInfo:GetPerkText(perks[1])
					if self.settings.show_perkdeck_progression then
						perk_prog = tonumber(perks[2])
						if not (perk_prog == 9 and self.settings.hide_complete_perkdeck_progression) then
							if self.settings.show_perkdeck_progression_graphically then
								show_progbar = true
							else
								perk_text = perk_text .. ' (' .. perks[2] .. '/9)'
							end
						end
					end
				end

				local peer_level = is_local_peer and managers.experience:current_level() or peer:level()
				sp_anomaly = peer_level and (skillpoints > (peer_level + 2 * math.floor(peer_level / 10)))
			end
		end
	end

	return skills_text, perk_text, perk_prog, sp_anomaly, show_progbar, is_local_peer, skills_string
end

function LobbyPlayerInfo:GetApiPlayTimeCallback(steamid, page)
	local play_time = ''
	if type(page) == 'string' then
		local data = json.decode(page)
		local game_list = data and data.response and data.response.games
		if type(game_list) == 'table' then
			for _, game in pairs(game_list) do
				if game.appid == 218620 then
					play_time = (math.floor(game.playtime_forever / 60)) .. managers.localization:text('lpi_hours')
					break
				end
			end
		end
	end
	self.play_times[steamid] = play_time
end

function LobbyPlayerInfo:GetPlayTimeCallback(steamid, page)
	local play_time = ''
	if type(page) == 'string' then
		local mark_start = 'var rgGames =.'
		local mark_end = '.var rgChangingGames'
		local _, pos_start = page:find(mark_start)
		if pos_start then
			local pos_end = page:find(mark_end, pos_start)
			if pos_end and pos_end - pos_start > 7 then
				local data = json.decode(page:sub(pos_start, pos_end))
				play_time = '[game not found]'
				if data then
					for i = 1, #data do
						if data[i].appid == 218620 then
							play_time = data[i].hours_forever .. managers.localization:text('lpi_hours')
							break
						end
					end
				end
			end
		end

		if page:find('class="profile_ban"') then
			play_time = play_time == '' and 'VAC' or (play_time .. ' and VAC')
		end
	end
	self.play_times[steamid] = play_time
end

function LobbyPlayerInfo.CreatePeerSpecialization(panel, peer_id)
	local caption = panel:text({
		text = '',
		align = 'center',
		alpha = 0,
		vertical = 'top',
		font_size = tweak_data.menu.pd2_small_font_size,
		font = tweak_data.menu.pd2_small_font,
		layer = 2
	})

	local bg = panel:bitmap({
		name = 'fixed',
		layer = 0,
		color = Color.white,
		blend_mode = 'sub',
		alpha = 0,
		texture = 'guis/textures/pd2/shared_tab_box',
	})

	local prog = obj_prog or panel:bitmap({
		name = 'fixed',
		layer = 1,
		color = tweak_data.chat_colors[peer_id],
		blend_mode = 'add',
		alpha = 0,
		texture = 'guis/textures/pd2/shared_tab_box',
	})

	return caption, bg, prog
end

function LobbyPlayerInfo:SetPeerSpecialization(obj_caption, obj_bg, obj_prog, peer_id, visible, perk_prog, mouse_over, show_progbar, text)
	-- caption
	obj_caption:set_text(text)
	local _, _, w, h = obj_caption:text_rect()
	obj_caption:set_size(w, h)
	local perk_color = tweak_data.chat_colors[peer_id]
	if show_progbar then
		perk_color = perk_prog == 0 and Color('e60000') or tweak_data.screen_colors.text
	end
	obj_caption:set_color(perk_color)
	obj_caption:set_blend_mode(show_progbar and 'normal' or 'add')
	obj_caption:set_visible(visible)
	UpdateAlpha(obj_caption, self.settings.show_perkdeck_mode, mouse_over)

	-- progression background
	h = h + h % 2
	w = math.max(w + (w % 2) + 20, 80)
	obj_bg:set_size(w, h)
	obj_bg:set_center_y(obj_caption:center_y())
	obj_bg:set_center_x(obj_caption:center_x())
	obj_bg:set_visible(visible and show_progbar)
	UpdateAlpha(obj_bg, self.settings.show_perkdeck_mode, mouse_over, 0.2)

	-- progression
	h = h - 2
	w = (w - 2) * perk_prog / 9
	obj_prog:set_size(w, h)
	obj_prog:set_center_y(obj_bg:center_y())
	obj_prog:set_left(obj_bg:left() + 1)
	obj_prog:set_visible(visible and show_progbar)
	UpdateAlpha(obj_prog, self.settings.show_perkdeck_mode, mouse_over, 0.4)
end

local sl3_height = 40
function LobbyPlayerInfo:CreatePeerSkills(panel)
	local obj
	if self.settings.skills_layout == 3 then
		local width = 6
		local spacing1 = 1
		local spacing2 = 3
		obj = panel:panel({
			x = 0,
			y = 0,
			w = 15 * width + 14 * spacing1 + 4 * spacing2,
			h = sl3_height
		})
		local c1 = Color(255,   0,  91, 255) / 255
		local c2 = Color(255, 255,  30,   0) / 255
		local c3 = Color(255, 216, 255,   0) / 255
		local c4 = Color(255,   0, 255,  95) / 255
		local c5 = Color(255, 162,   0, 255) / 255
		local colors = {
			c1, c1, c1,
			c2, c2, c2,
			c3, c3, c3,
			c4, c4, c4,
			c5, c5, c5
		}
		local x = 0
		for i = 1, 15 do
			local bg = obj:bitmap({
				name = 'bg_' .. i,
				layer = 0,
				color = colors[i],
				blend_mode = 'normal',
				texture = 'guis/textures/pd2/shared_tab_box',
				alpha = 0.3,
				w = width,
				h = sl3_height,
				x = x,
				y = 0,
			})

			local fg = obj:bitmap({
				name = 'fg_' .. i,
				layer = 1,
				color = colors[i],
				blend_mode = 'normal',
				texture = 'guis/textures/pd2/shared_tab_box',
				alpha = 1,
				w = width,
				h = 0,
				x = x,
				y = 0,
			})

			x = x + width + spacing1 + ((i % 3 == 0) and spacing2 or 0)
		end
	else
		obj = panel:text({
			text = '',
			alpha = 0,
			align = 'right',
			vertical = 'top',
			font_size = self:GetFontSizeForSkills(),
			font = tweak_data.menu.pd2_small_font,
			layer = 0,
			blend_mode = 'add'
		})
	end
	return obj
end

function LobbyPlayerInfo:SetPeerSkills(obj, visible, sp_anomaly, mouse_over, text, raw_list)
	if self.settings.skills_layout == 3 then
		if type(raw_list) == 'string' then
			local skills = raw_list:split('_')
			if #skills == 15 then
				for i = 1, 15 do
					local child = obj:child('fg_' .. i)
					if child then
						local points = tonumber(skills[i])
						child:set_height(points / 46 * sl3_height)
						child:set_bottom(sl3_height)
					end
				end
			end
		end
	else
		obj:set_text(text)
		obj:set_font_size(self:GetFontSizeForSkills())
		local _, _, w, h = obj:text_rect()
		obj:set_size(w, h)
		obj:set_color(sp_anomaly and Color('e60000') or Color('ababab'))
	end
	obj:set_visible(visible)
	UpdateAlpha(obj, sp_anomaly and 3 or self.settings.show_skills_mode, mouse_over)
end

function LobbyPlayerInfo:CreatePeerPlaytime(panel)
	local txt = panel:text({
		text = '',
		align = 'center',
		alpha = 0,
		vertical = 'bottom',
		font_size = self:GetFontSizeForPlayTime(),
		font = tweak_data.menu.pd2_small_font,
		layer = 0,
		color = Color('ababab'),
		blend_mode = 'add'
	})
	return txt
end

function LobbyPlayerInfo:SetPeerPlaytime(obj, visible, mouse_over, text)
	obj:set_text(text or '')
	obj:set_font_size(self:GetFontSizeForPlayTime())
	local _, _, w, h = obj:text_rect()
	obj:set_size(w, h)
	obj:set_visible(visible)
	UpdateAlpha(obj, self.settings.show_play_time_mode, mouse_over)
end

function LobbyPlayerInfo.CreatePeerTalking(panel)
	local voice_icon, voice_texture_rect = tweak_data.hud_icons:get_icon_data('wp_talk')
	local bitmap = panel:bitmap({
		texture = voice_icon,
		layer = 0,
		texture_rect = voice_texture_rect,
		w = voice_texture_rect[3],
		h = voice_texture_rect[4],
		color = color,
		blend_mode = 'add',
		alpha = 0
	})
	return bitmap
end

function LobbyPlayerInfo.SetPeerTalking(obj, peer_id, is_local_peer, visible)
	obj:set_visible(visible)
	local talking
	if is_local_peer and not managers.network.voice_chat._push_to_talk then
		talking = managers.network.voice_chat._enabled
	else
		talking = managers.network.voice_chat._users_talking[peer_id] and managers.network.voice_chat._users_talking[peer_id].active
	end
	UpdateAlpha(obj, talking and 3 or 1)
end

local lpi_original_contractboxgui_setcharacterpanelalpha = ContractBoxGui.set_character_panel_alpha
function ContractBoxGui:set_character_panel_alpha(peer_id, alpha)
	lpi_original_contractboxgui_setcharacterpanelalpha(self, peer_id, alpha)

	if self._peers_spec and self._peers_spec[peer_id] then
		self._peers_spec[peer_id]:set_alpha(alpha)
	end
	if self._peers_spec_bg and self._peers_spec_bg[peer_id] then
		self._peers_spec_bg[peer_id]:set_alpha(alpha)
	end
	if self._peers_spec_bg_p and self._peers_spec_bg_p[peer_id] then
		self._peers_spec_bg_p[peer_id]:set_alpha(alpha)
	end
	if self._peers_skills and self._peers_skills[peer_id] then
		self._peers_skills[peer_id]:set_alpha(alpha)
	end
	if self._peers_play_time and self._peers_play_time[peer_id] then
		self._peers_play_time[peer_id]:set_alpha(alpha)
	end
end

-- Inspect
function DisplayPlayerStatus(peer)
	local status = LobbyPlayerInfo.pd2stats_player_status[peer:user_id()]
	if not status then
		return
	end

	if status.error_code ~= 0 then
		managers.chat:_receive_message(ChatManager.GAME, 'pd2stats', peer:name() .. ': ' .. status.error_string:gsub('_', ' '), tweak_data.system_chat_color)
		return
	end

	if status.cheater then
		managers.chat:_receive_message(ChatManager.GAME, 'pd2stats', peer:name() .. ' is not OK:', tweak_data.system_chat_color)
		for i = 1, status.reason_index do
			local istr = tostring(i)
			managers.chat:_receive_message(ChatManager.GAME, 'pd2stats', istr .. '/ ' .. status['reason_' .. istr]:gsub('_', ' '), tweak_data.system_chat_color)
		end

	else
		managers.chat:_receive_message(ChatManager.GAME, 'pd2stats', peer:name() .. ' is OK.', tweak_data.system_chat_color)
	end
end

function ContractBoxGui:GetPlayerStatusFromPD2StatsCallback(peer_id, page)
	local peer = managers.network:session():peer(peer_id)
	if not peer then
		return
	end

	if not page or type(page) ~= 'string' or page:sub(1, 1) ~= '{' then
		managers.chat:_receive_message(ChatManager.GAME, 'pd2stats', 'No results for ' .. peer:name() .. '.', tweak_data.system_chat_color)
		return
	end

	local status = loadstring('return ' .. page)()
	LobbyPlayerInfo.pd2stats_player_status[peer:user_id()] = type(status) == 'table' and status or nil
	DisplayPlayerStatus(peer)
end

function ContractBoxGui:mouse_double_click(o, button, x, y)
	if y < 90 or y > 550 then
		return
	end

	if button == Idstring('0') then
		local peer = nil
		for i = 1, 4 do
			local lpeer = managers.network:session():peer(i)
			if lpeer then
				local peer_pos = managers.menu_scene:character_screen_position(i)
				if peer_pos and x > peer_pos.x - 90 and x < peer_pos.x + 90 then
					peer = lpeer
					break
				end
			end
		end
		if not peer then
			return
		end

		local steamid = peer:user_id()
		if type(LobbyPlayerInfo.pd2stats_player_status[steamid]) == 'table' then
			DisplayPlayerStatus(peer)
		end
		if LobbyPlayerInfo.pd2stats_player_status[steamid] then
			return
		end

		LobbyPlayerInfo.pd2stats_player_status[steamid] = 'in progress'
		managers.chat:_receive_message(ChatManager.GAME, 'pd2stats', peer:name() .. ', query sent.', tweak_data.system_chat_color)

		local url = 'http://api.pd2stats.com/cheater/v3/?type=lua&id=' .. steamid
		dohttpreq(url, callback(self, self, 'GetPlayerStatusFromPD2StatsCallback', peer:id()))
	end
end

CrimeSpreeContractBoxGui.mouse_double_click = ContractBoxGui.mouse_double_click
CrimeSpreeContractBoxGui.GetPlayerStatusFromPD2StatsCallback = ContractBoxGui.GetPlayerStatusFromPD2StatsCallback
