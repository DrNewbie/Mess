if TimerManager and TimerManager.timer then
	for _, v in pairs({"player", "game", "game_animation"}) do
		TimerManager:timer(Idstring(v)):set_multiplier(1)
	end
end