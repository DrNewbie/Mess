_G.ee198082e5d36d96 = _G.ee198082e5d36d96 or {}

Hooks:PostHook(CrimeSpreeManager, "_setup_global_from_mission_id", "F_"..Idstring("PostHook:CrimeSpreeManager:_setup_global_from_mission_id:One Down Crime Spree"):key(), function(self, mission_id)
	local mission_data = self:get_mission(mission_id)
	if mission_data then
		local is_one_down = ee198082e5d36d96.settings and ee198082e5d36d96.settings.ee198082e5d36d96_toggle_value or false
		if type(is_one_down) ~= type(true) then
			is_one_down = false
		end
		Global.game_settings.one_down = is_one_down
	end
end)