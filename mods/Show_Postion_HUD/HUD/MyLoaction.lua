local ThisModPath = ModPath

local ThisModConfigFile = ThisModPath.."/HUD/MyLoaction.json"

_G.AddAddonInfoToHUD = _G.AddAddonInfoToHUD or {}

if not _G.AddAddonInfoToHUD.ThisModPath then
	return
end

if not io.file_is_readable(ThisModConfigFile) then
	return
end

if string.lower(RequiredScript) == "lib/managers/hudmanagerpd2" then
	HUDMyLoaction = HUDMyLoaction or class()
	
	function HUDMyLoaction:init()
		local __data = io.load_as_json(ThisModConfigFile)
		self.this_hud_panel, self.this_hud_box, self.this_hud_box_text, self.this_hud_box_icon = _G.AddAddonInfoToHUD.Init(__data)
	end
	
	function HUDMyLoaction:update(__pos, __rot)
		if not self.this_hud_panel then
			return
		end
		self.this_hud_box_text:set_text(string.format("X:%.f_Y:%.f_Z:%.f", __pos.x, __pos.y, __pos.z))
	end
	 
	Hooks:PostHook(HUDManager, "_setup_player_info_hud_pd2", "AAAMyLoactionInitToCreate", function(self)
		self._hud_AAAMyLoaction = HUDMyLoaction:new()
	end)
		
	function HUDManager:AAAMyLoaction(__pos, __rot)
		self._hud_AAAMyLoaction:update(__pos, __rot)
	end

elseif string.lower(RequiredScript) == "lib/units/beings/player/playerdamage" then
	local is_delay_bool = 0
	Hooks:PostHook(PlayerDamage, "update", "AAAMyLoactionUpdateLoop", function(self)
		if is_delay_bool <= 0 and managers.hud and managers.hud.AAAMyLoaction and self._unit and alive(self._unit) then
			is_delay_bool = 3
			managers.hud:AAAMyLoaction(self._unit:position(), self._unit:rotation())
		else
			is_delay_bool = is_delay_bool - 1
		end
	end)
end