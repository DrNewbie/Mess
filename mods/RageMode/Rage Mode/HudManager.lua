_G.Rage_Special = _G.Rage_Special or {}
Rage_Special_HUD = Rage_Special_HUD or class()

dofile("mods/Rage Mode/HUDHeistTimer.lua")
dofile("mods/Rage Mode/lua/HUD.lua")

Hooks:PostHook(HUDManager, "_setup_player_info_hud_pd2", "setup_Rage_Special_HUD", function(self)
	if managers.player:has_category_upgrade("temporary", "berserker_damage_multiplier") then
		self.Rage_Special_HUD = Rage_Special_HUD:new(managers.gui_data:create_fullscreen_workspace():panel())
	end
end)