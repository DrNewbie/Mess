local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local lpi_original_lobbycharacterdata_init = LobbyCharacterData.init
function LobbyCharacterData:init(...)
	lpi_original_lobbycharacterdata_init(self, ...)

	self._peer_spec, self._peer_spec_bg, self._peer_spec_bg_p = LobbyPlayerInfo.CreatePeerSpecialization(self._panel, self._peer:id())
	self._peer_skills = LobbyPlayerInfo:CreatePeerSkills(self._panel)
	self._peer_play_time = LobbyPlayerInfo:CreatePeerPlaytime(self._panel)
	self._peer_talking = LobbyPlayerInfo.CreatePeerTalking(self._panel)

	self._panel:set_height(256)
	LPITeamBox.contractboxgui = self
	self._ready = true
end

local lpi_original_lobbycharacterdata_updatepeerid = LobbyCharacterData.update_peer_id
function LobbyCharacterData:update_peer_id(new_peer_id)
	lpi_original_lobbycharacterdata_updatepeerid(self, new_peer_id)

	if not managers.network:session():peer(new_peer_id) then
		LPITeamBox._skills[new_peer_id] = nil
		LPITeamBox:RebuildData()
		LPITeamBox:Update()
	end
end

local lpi_original_lobbycharacterdata_updatecharacter = LobbyCharacterData.update_character
function LobbyCharacterData:update_character()
	lpi_original_lobbycharacterdata_updatecharacter(self)

	local peer = self._peer
	if not self._ready or not self:_can_update() then
		return
	end

	local peer_id = peer:id()
	local skills_text, perk_text, perk_prog, sp_anomaly, show_progbar, is_local_peer, skills_string = LobbyPlayerInfo:GetPeerData(peer_id, peer)
	LPITeamBox._skills[peer_id] = skills_string
	if self._skills ~= skills_string then
		LPITeamBox:RebuildData()
		LPITeamBox:Update()
	end
	self._skills = skills_string
	local visible = not not peer

	local mx, my = managers.mouse_pointer:modified_mouse_pos()
	mx = mx - self._panel:left()
	my = my - self._panel:top()
	local mouse_over = mx > self._name_text:left()
		and mx < self._name_text:right()
		and my < self._name_text:bottom() + self._name_text:height() * 6
		and my > self._name_text:top()    - self._name_text:height() * 3

	-- Play time
	local steamid = peer and peer:user_id() or ''
	LobbyPlayerInfo:SetPeerPlaytime(self._peer_play_time, visible, mouse_over, LobbyPlayerInfo.play_times[steamid])
	LobbyPlayerInfo.RelocateAbove(self._peer_play_time, self._spree_text)

	-- Talkers
	LobbyPlayerInfo.SetPeerTalking(self._peer_talking, peer_id, is_local_peer, visible)
	LobbyPlayerInfo.RelocateAbove(self._peer_talking, self._peer_play_time)

	-- Specialization
	LobbyPlayerInfo:SetPeerSpecialization(self._peer_spec, self._peer_spec_bg, self._peer_spec_bg_p, peer_id, visible, perk_prog, mouse_over, show_progbar, perk_text)
	LobbyPlayerInfo.RelocateBelow(self._peer_spec, self._state_text)

	-- Skills
	LobbyPlayerInfo:SetPeerSkills(self._peer_skills, visible, sp_anomaly, mouse_over, skills_text, skills_string)
	local neighbour = LobbyPlayerInfo.settings.show_perkdeck_mode == 1 and self._state_text or self._peer_spec
	LobbyPlayerInfo.RelocateBelow(self._peer_skills, neighbour)

	local d = self._peer_talking:top()
	for i, child in pairs(self._panel:children()) do
		local ctop = child:top()
		if ctop < 300 and child:name() ~= 'fixed' then
			child:set_top(ctop - d)
		end
	end
end
