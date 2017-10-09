AutoCasino.init = false
managers.menu:active_menu().logic:navigate_back(true)
local _dialog_data = { 
	title = "[Auto Casino]",
	text = "Disable",
	button_list = {{ text = "OK", is_cancel_button = true }},
	id = tostring(math.random(0,0xFFFFFFFF))
}
managers.system_menu:show(_dialog_data)