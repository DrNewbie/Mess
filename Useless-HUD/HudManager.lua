_G.UselessHUD = _G.UselessHUD or {}
Uselesshud_Weather = Uselesshud_Weather or class()
Uselesshud_Stock = Uselesshud_Stock or class()

dofile("mods/Useless-HUD/HUDHeistTimer.lua")

dofile("mods/Useless-HUD/Weather/City_ID_List.lua")
dofile("mods/Useless-HUD/Weather/Weather.lua")

dofile("mods/Useless-HUD/Stock/Stock.lua")

Hooks:PostHook(HUDManager, "_setup_player_info_hud_pd2", "setup_Uselesshud_Weather", function(self)
    self._uselesshud_weather = Uselesshud_Weather:new(managers.gui_data:create_fullscreen_workspace():panel())
    self._uselesshud_stock = Uselesshud_Stock:new(managers.gui_data:create_fullscreen_workspace():panel())
end)