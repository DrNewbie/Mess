_G.Rage_Special = _G.Rage_Special or {}
Rage_Special_HUD = Rage_Special_HUD or class()
Rage_Special.ModPath = ModPath

dofile(Rage_Special.ModPath .. "/HUDHeistTimer.lua")
dofile(Rage_Special.ModPath .. "/lua/HUD.lua")

Hooks:PostHook(HUDManager, "_setup_player_info_hud_pd2", "setup_Rage_Special_HUD", function(self)
	self.Rage_Special_HUD = Rage_Special_HUD:new(managers.gui_data:create_fullscreen_workspace():panel())
end)