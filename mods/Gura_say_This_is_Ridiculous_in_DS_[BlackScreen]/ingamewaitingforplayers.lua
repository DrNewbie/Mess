local ThisModPath = ModPath
local mod_ids = Idstring("Gura say This is Ridiculous in DS [BlackScreen]"):key()
local func1 = "F_"..Idstring("func1::"..mod_ids):key()
local func2 = "F_"..Idstring("func2::"..mod_ids):key()
local func3 = "F_"..Idstring("func3::"..mod_ids):key()

Hooks:PostHook(IngameWaitingForPlayersState, "sync_start", func1, function(self)
	self[func2] = Application:time() + 1.5
end)

Hooks:PostHook(IngameWaitingForPlayersState, "update", func3, function(self, t)
	if self[func2] and self[func2] < t and blt.xaudio and Global.game_settings.difficulty == "sm_wish" then
        self[func2] = nil
		blt.xaudio.setup()
        XAudio.Source:new(XAudio.Buffer:new(ThisModPath .. "ogg_fac0173a01654102.ogg"))
    end
end)