local __escape_days =  {
	"escape_cafe",
	"escape_park",
	"escape_street",
	"escape_overpass",
	"escape_garage",
	"escape_overpass_night",
	"escape_cafe_day",
	"escape_park_day"
}

Hooks:PostHook(DialogManager, "init", "F_"..Idstring("PostHook:DialogManager:init:Make every heist have escape"):key(), function(self)
	if not Global.game_settings or not managers.job then

	else
		if Global.game_settings.single_player or (Network and not Network:is_client()) then
			if not table.contains(__escape_days, tostring(Global.game_settings.level_id)) and not self.__add_escape_days_to_heist then
				self.__add_escape_days_to_heist = true
				managers.job:set_next_interupt_stage(table.random(__escape_days))
			end
		end
	end
end)