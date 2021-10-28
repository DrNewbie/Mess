local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local Hook0 = "F_"..Idstring("HUDManager:_setup_player_info_hud_pd2:"..ThisModIds):key()

function HUDManager:_create_mutator(hud)
	if managers.mutators:is_mutator_active(MutatorBirthday) and not _G.IS_VR then
		hud = hud or managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)
		self._hud_mutator = HUDMutator:new(hud)
	end
end

function HUDManager:add_buff(buff_id, name_id, color, time_left, show_time_left)
	if not _G.IS_VR then
		self._hud_mutator:add_buff(buff_id, name_id, color, time_left, show_time_left)
	end
end

function HUDManager:update_mutator_hud(t, dt)
	if not _G.IS_VR then
		self._hud_mutator:update(t, dt)
	end
end

Hooks:PostHook(HUDManager, "_setup_player_info_hud_pd2", Hook0, function(self)
	local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)
	self:_create_mutator(hud)
end)