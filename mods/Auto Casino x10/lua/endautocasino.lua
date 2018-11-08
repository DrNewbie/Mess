AutoCasino.init = false
managers.menu:active_menu().logic:navigate_back(true)
local _dialog_data = { 
	title = "[Auto Casino]",
	text = "Disable",
	button_list = {{ text = "OK", is_cancel_button = true }},
	id = tostring(math.random(0,0xFFFFFFFF))
}
managers.system_menu:show(_dialog_data)
TimerManager:timer(Idstring("player")):set_multiplier(1)
TimerManager:timer(Idstring("game")):set_multiplier(1)
TimerManager:timer(Idstring("game_animation")):set_multiplier(1)