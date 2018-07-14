if TimerManager and TimerManager.timer then
	if TimerManager:timer(Idstring("game")) then
		TimerManager:timer(Idstring("game")):set_multiplier(1)
	end
	if TimerManager:timer(Idstring("player")) then
		TimerManager:timer(Idstring("player")):set_multiplier(1)
	end
	if TimerManager:timer(Idstring("game_animation")) then
		TimerManager:timer(Idstring("game_animation")):set_multiplier(1)
	end
end