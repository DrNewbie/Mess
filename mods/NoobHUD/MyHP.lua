if string.lower(RequiredScript) == "lib/managers/hudmanagerpd2" then
	HUDQUAKEHP = HUDQUAKEHP or class()

	function HUDQUAKEHP:init(hud)
		self._hud_panel = hud.panel

		self.__quake_hp_panel = self._hud_panel:panel({
			name = "_quake_hp_counter_panel",
			visible = false,
			w = 400,
			h = 200
		})
		
		self.__quake_hp_panel:set_bottom(self._hud_panel:h()+64)
		self.__quake_hp_panel:set_center_x(self._hud_panel:w()*0.5)
			
		local _quake_hp_box = HUDBGBox_create(self.__quake_hp_panel, {w = 256, h = 128}, {})
		
		self._text = _quake_hp_box:text({
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
		

		local _quake_hp_icon
		if DB:has(Idstring("texture"), Idstring("guis/textures/pd2/noob_hud/better_icon/health")) then
			_quake_hp_icon = self.__quake_hp_panel:bitmap({
				name = "_quake_hp_icon",
				texture = "guis/textures/pd2/noob_hud/better_icon/health",
				valign = "top",
				layer = 1,
				w = 96,
				h = 96
			})
		else
			_quake_hp_icon = self.__quake_hp_panel:bitmap({
				name = "_quake_hp_icon",
				texture = "guis/textures/pd2/skilltree/icons_atlas",
				texture_rect = { 1 * 64, 1 * 64, 64, 64 },
				valign = "top",
				layer = 1,
				w = 96,
				h = 96
			})
		end
		_quake_hp_icon:set_right(_quake_hp_box:parent():w())
		_quake_hp_icon:set_center_y(_quake_hp_box:h() / 2)
		_quake_hp_box:set_right(_quake_hp_icon:left())
		
		self.__quake_hp_panel:set_visible(true)
	end
		
	function HUDQUAKEHP:update(t)
		t = math.max(t, 0)
		self._text:set_text(string.format("%.f", t))
		self._text:set_color(Color(1, 1, 1))
	end
	 
		Hooks:PostHook(HUDManager, "_setup_player_info_hud_pd2", "F_"..Idstring("PostHook:HUDManager:_setup_player_info_hud_pd2:HUDQUAKEHP:OwO"):key(), function(self)
			self._hud_quake_hp = HUDQUAKEHP:new(managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2))
		end)
		
	function HUDManager:quake_hp(t)
		self._hud_quake_hp:update(t)
	end

elseif string.lower(RequiredScript) == "lib/units/beings/player/playerdamage" then
	Hooks:PostHook(PlayerDamage, "update", "F_"..Idstring("PostHook:PlayerDamage:update:HUDQUAKEHP:OwO"):key(), function(self)
		if managers.hud and managers.hud.quake_hp then
			managers.hud:quake_hp(self:health_ratio()*100)
		end
	end)
end