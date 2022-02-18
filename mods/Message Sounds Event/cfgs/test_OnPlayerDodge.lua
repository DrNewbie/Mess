_G.MessageSoundsEventt = _G.MessageSoundsEventt or {}

_G.MessageSoundsEventt.AddMsgFunc("OnPlayerDodge", "a_test_OnPlayerDodge_000", function()
	if managers.player and managers.player:player_unit() then
		_G.MessageSoundsEventt.PlaySoundRandom("OnPlayerDodge")
	end
	return
end)