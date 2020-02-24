if string.lower(RequiredScript) == "lib/managers/hudmanagerpd2" then
	HUDQUAKEARMOR = HUDQUAKEARMOR or class()

	function HUDQUAKEARMOR:init(hud)
		self._hud_panel = hud.panel

		self.__quake_armor_panel = self._hud_panel:panel({
			name = "_quake_armor_counter_panel",
			visible = false,
			w = 400,
			h = 200
		})
		
		self.__quake_armor_panel:set_bottom(self._hud_panel:h()+64)
		self.__quake_armor_panel:set_right(self._hud_panel:w())
			
		local _quake_armor_box = HUDBGBox_create(self.__quake_armor_panel, {w = 256, h = 128}, {})
		
		self._text = _quake_armor_box:text({
			name = "text",
			text = "0",
			valign = "center",
			align = "center",
			vertical = "center",
			w = 256,
			h = 128,
			layer = 1,
			color = Color.white,
			font = "fonts/font_large_mf",
			font_size = 96
		})
		

		local _quake_armor_icon		
		if DB:has(Idstring("texture"), Idstring("guis/textures/pd2/noob_hud/better_icon/armor")) then
			_quake_armor_icon = self.__quake_armor_panel:bitmap({
				name = "_quake_armor_icon",
				texture = "guis/textures/pd2/noob_hud/better_icon/armor",
				valign = "top",
				layer = 1,
				w = 96,
				h = 96
			})
		else
			_quake_armor_icon = self.__quake_armor_panel:bitmap({
				name = "_quake_armor_icon",
				texture = "guis/textures/pd2/skilltree/icons_atlas",
				texture_rect = { 2 * 64, 12 * 64, 64, 64 },
				valign = "top",
				layer = 1,
				w = 96,
				h = 96
			})
		end

		
		_quake_armor_icon:set_right(_quake_armor_box:parent():w())
		_quake_armor_icon:set_center_y(_quake_armor_box:h() / 2)
		_quake_armor_box:set_right(_quake_armor_icon:left())
		
		self.__quake_armor_panel:set_visible(true)
	end
		
	function HUDQUAKEARMOR:update(t)
		t = math.max(t, 0)
		self._text:set_text(string.format("%.f", t))
		self._text:set_color(Color(1, 1, 1))
	end
	 
		Hooks:PostHook(HUDManager, "_setup_player_info_hud_pd2", "F_"..Idstring("PostHook:HUDManager:_setup_player_info_hud_pd2:HUDQUAKEARMOR:OwO"):key(), function(self)
			self._hud_quake_armor = HUDQUAKEARMOR:new(managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2))
		end)
		
	function HUDManager:quake_armor(t)
		self._hud_quake_armor:update(t)
	end

elseif string.lower(RequiredScript) == "lib/units/beings/player/playerdamage" then
	Hooks:PostHook(PlayerDamage, "update", "F_"..Idstring("PostHook:PlayerDamage:update:HUDQUAKEARMOR:OwO"):key(), function(self)
		if managers.hud and managers.hud.quake_armor then
			managers.hud:quake_armor(self:armor_ratio()*100)
		end
	end)
end