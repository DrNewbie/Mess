Hooks:PostHook(GroupAIStateBase, "init", "F_"..Idstring("PostHook:GroupAIStateBase:init:Last Man Standing Track Event"):key(), function(self)
	self._lmste_OwO_t = 5
	self._lmste_OwO_event = 0
	self._lmste_OwO_old_track = ""
end)

Hooks:PostHook(GroupAIStateBase, "update", "F_"..Idstring("PostHook:GroupAIStateBase:update:Last Man Standing Track Event"):key(), function(self, t, dt)
	if self._lmste_OwO_t then
		self._lmste_OwO_t = self._lmste_OwO_t - dt
		if self._lmste_OwO_t < 0 then self._lmste_OwO_t = nil end
	else
		self._lmste_OwO_t = 5
		local player = managers.player:player_unit()
		local all_criminals = self:all_char_criminals()
		local _is_lmste_tmp
		if player and player:base() then
			if self:num_alive_criminals() == 1 then
				_is_lmste_tmp = true
			end
		end
		if _is_lmste_tmp then
			if self._lmste_OwO_event == 0 then
				self._lmste_OwO_event = 1
				managers.music:stop()
				self._lmste_OwO_old_track = Global.music_manager.current_track
				Global.music_manager.source:set_switch("music_randomizer", "track_54")
				managers.music:post_event("music_heist_" .. "assault")
			end
		else
			if self._lmste_OwO_event == 1 then
				self._lmste_OwO_event = 0
				managers.music:stop()
				Global.music_manager.current_track = self._lmste_OwO_old_track
				Global.music_manager.source:set_switch("music_randomizer", Global.music_manager.current_track)
				managers.music:post_event("music_heist_" .. (self._task_data.assault.phase or "setup"))
			end
		end
	end
end)