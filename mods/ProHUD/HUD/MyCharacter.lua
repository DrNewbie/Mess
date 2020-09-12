if string.lower(RequiredScript) == "lib/managers/hudmanagerpd2" then
	HUDQUAKEMYMASK = HUDQUAKEMYMASK or class()

	function HUDQUAKEMYMASK:init(hud)
		self._hud_panel = hud.panel

		self.__quake_my_icon_panel = self._hud_panel:panel({
			name = "_quake_my_icon_counter_panel",
			visible = false,
			w = 200,
			h = 100
		})
		
		self.__quake_my_icon_panel:set_center(self._hud_panel:center())
		self.__quake_my_icon_panel:set_center_x(self._hud_panel:center_x() * 0.35)
		self.__quake_my_icon_panel:set_center_y(self._hud_panel:center_y() * 1.75)
			
		local _quake_my_icon_box = HUDBGBox_create(self.__quake_my_icon_panel, {w = 64, h = 64}, {})
		
		self._text = _quake_my_icon_box:text({
			name = "text",
			text = "0",
			valign = "center",
			align = "center",
			vertical = "center",
			w = 64,
			h = 64,
			layer = 1,
			color = Color.white,
			font = "fonts/font_large_mf",
			font_size = 24
		})
		

		local _quake_my_icon_icon
		
		_quake_my_icon_icon = self.__quake_my_icon_panel:bitmap({
			name = "_quake_my_icon_icon",
			texture = "guis/textures/pd2/dice_icon",
			valign = "top",
			layer = 1,
			w = 64,
			h = 64
		})
		_quake_my_icon_box:set_center(_quake_my_icon_icon:center())
		
		self.__quake_my_icon_panel:set_visible(true)
		
		self._text:set_visible(false)
	end
		
	function HUDQUAKEMYMASK:update(_unit)
		local character = managers.criminals:character_name_by_unit(_unit)
		local texture = character and managers.blackmarket:get_character_icon(character) or "guis/textures/pd2/dice_icon"
		self.__quake_my_icon_panel:child("_quake_my_icon_icon"):set_image(texture)
		return texture
	end
	 
	Hooks:PostHook(HUDManager, "_setup_player_info_hud_pd2", "F_"..Idstring("PostHook:HUDManager:_setup_player_info_hud_pd2:HUDQUAKEMYMASK:OwO"):key(), function(self)
		self._hud_quake_my_icon = HUDQUAKEMYMASK:new(managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2))
	end)
		
	function HUDManager:quake_my_icon(_unit)
		return self._hud_quake_my_icon:update(_unit)
	end

elseif string.lower(RequiredScript) == "lib/units/beings/player/playerdamage" then
	Hooks:PostHook(PlayerDamage, "update", "F_"..Idstring("PostHook:PlayerDamage:update:HUDQUAKEMYMASK:OwO"):key(), function(self)
		if not self._hud_quake_my_icon_done and managers.hud and managers.hud.quake_my_icon and self._unit and self._unit:inventory() and self._unit:inventory():equipped_unit() then
			local __ans = managers.hud:quake_my_icon(self._unit)
			if tostring(__ans) ~= "guis/textures/pd2/dice_icon" then
				self._hud_quake_my_icon_done = true
			end
		end
	end)
end