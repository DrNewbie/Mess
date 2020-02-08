local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local function _get_skills_perk_text(peer)
	local skills, perk = 'Invalid data', '?'

	local peer_skills = peer:skills()
	peer_skills = peer_skills and peer_skills:split('-')
	if #peer_skills == 2 then
		local s = peer_skills[1]:split('_')
		local p = peer_skills[2]:split('_')

		if #s == 15 and #p == 2 then
			local man_loc = managers.localization
			local ppt = LobbyPlayerInfo:GetSkillPointsPerTree(s)
			local abb_len = LobbyPlayerInfo._abbreviation_length_v
			local am = utf8.sub(man_loc:text('st_menu_mastermind'), 1, abb_len)
			local ae = utf8.sub(man_loc:text('st_menu_enforcer'), 1, abb_len)
			local at = utf8.sub(man_loc:text('st_menu_technician'), 1, abb_len)
			local ag = utf8.sub(man_loc:text('st_menu_ghost'), 1, abb_len)
			local af = utf8.sub(man_loc:text('st_menu_hoxton_pack'), 1, abb_len)
			skills = string.format(LobbyPlayerInfo.skills_layouts[1], am, ppt[1], ae, ppt[2], at, ppt[3], ag, ppt[4], af, ppt[5])

			abb_len = 5
			local perk_name = LobbyPlayerInfo:GetPerkText(p[1])
			perk = string.format('%s%s %s/9', utf8.sub(perk_name, 1, abb_len), (perk_name:len() > abb_len and '.' or ''), p[2])
		end
	end

	return skills, perk
end

local lpi_original_teamloadoutitem_setslotoutfit = TeamLoadoutItem.set_slot_outfit
function TeamLoadoutItem:set_slot_outfit(slot, criminal_name, outfit)
	local mbg = managers.menu_component._mission_briefing_gui
	if mbg and mbg.lpi_sptxt then
		sptxt = mbg.lpi_sptxt[slot]
		if sptxt then
			local peer = managers.network:session():peer(slot)
			if peer then
				sptxt.skills, sptxt.perk = _get_skills_perk_text(peer)
			end
		end
	end

	local txt = outfit and LobbyPlayerInfo.settings.show_perkdeck_in_loadout and LobbyPlayerInfo:GetPerkTextId(outfit.skills.specializations[1]) or criminal_name
	lpi_original_teamloadoutitem_setslotoutfit(self, slot, txt, outfit)
end

local lpi_original_missionbriefinggui_mousemoved = MissionBriefingGui.mouse_moved
function MissionBriefingGui:mouse_moved(x, y)
	if not alive(self._panel) or not alive(self._fullscreen_panel) or not self._enabled then
		return
	end
	if game_state_machine:current_state().blackscreen_started and game_state_machine:current_state():blackscreen_started() then
		return
	end

	local hmb = managers.hud._hud_mission_briefing
	if hmb and not hmb._singleplayer then
		self.lpi_sptxt = self.lpi_sptxt or {}

		for peer_id = 1, 4 do
			local sptxt = self.lpi_sptxt[peer_id]
			if sptxt then
				local slot = hmb._ready_slot_panel:child('slot_' .. tostring(peer_id))
				local backdrop_rect = hmb._backdrop:saferect_shape()
				local inside = slot:inside(x + backdrop_rect.x, y + backdrop_rect.y)
				slot:child('name'):set_text(inside and sptxt.skills or sptxt.name)
				slot:child('criminal'):set_text(inside and sptxt.perk or sptxt.criminal)

			else
				local peer = managers.network:session():peer(peer_id)
				local skillsperk = peer and peer:synched() and (peer == managers.network:session():local_peer() or peer:level()) and peer:skills()
				if skillsperk then
					sptxt = {}
					local slot = hmb._ready_slot_panel:child('slot_' .. tostring(peer_id))
					sptxt.name = slot:child('name'):text()
					sptxt.criminal = slot:child('criminal'):text()
					sptxt.skills, sptxt.perk = _get_skills_perk_text(peer)
					self.lpi_sptxt[peer_id] = sptxt
				end
			end
		end
	end

	return lpi_original_missionbriefinggui_mousemoved(self, x, y)
end

Hooks:Add('BaseNetworkSessionOnPeerRemoved', 'BaseNetworkSessionOnPeerRemoved_LobbyPlayerInfo_MissionBriefingGui', function(peer, peer_id, reason)
	local mbg = managers.menu_component._mission_briefing_gui
	if mbg and mbg.lpi_sptxt then
		mbg.lpi_sptxt[peer_id] = nil
	end
end)
