local _setfunc2 = HUDManager.blackscreen_fade_in_mid_text

function HUDManager:blackscreen_fade_in_mid_text()
	managers.network.matchmake:forced_private()
	managers.menu:show_warning_mod(1)
	managers.menu:show_warning_mod(2)
	managers.menu:show_warning_mod(3)
	managers.menu:show_warning_mod(4)
	managers.menu:show_warning_mod(5)
	return _setfunc2(self)
end

