if string.lower(RequiredScript) == "lib/managers/hudmanagerpd2" then
	HUDQUAKEAMMO = HUDQUAKEAMMO or class()

	function HUDQUAKEAMMO:init(hud)
		self._hud_panel = hud.panel

		self.__quake_ammo_panel = self._hud_panel:panel({
			name = "_quake_ammo_counter_panel",
			visible = false,
			w = 200,
			h = 100
		})
		
		self.__quake_ammo_panel:set_center(self._hud_panel:center())
		self.__quake_ammo_panel:set_center_x(self._hud_panel:center_x() * 1.25)
		self.__quake_ammo_panel:set_center_y(self._hud_panel:center_y() * 1.05)
			
		local _quake_ammo_box = HUDBGBox_create(self.__quake_ammo_panel, {w = 88, h = 64}, {})
		
		self._text = _quake_ammo_box:text({
			name = "text",
			text = "0",
			valign = "center",
			align = "center",
			vertical = "center",
			w = 88,
			h = 64,
			layer = 1,
			color = Color.white,
			font = "fonts/font_large_mf",
			font_size = 24
		})
		

		local _quake_ammo_icon
		if DB:has(Idstring("texture"), Idstring("guis/textures/pd2/noob_hud/better_icon/ammo")) then
			_quake_ammo_icon = self.__quake_ammo_panel:bitmap({
				name = "_quake_ammo_icon",
				texture = "guis/textures/pd2/noob_hud/better_icon/ammo",
				valign = "top",
				layer = 1,
				w = 64,
				h = 64
			})
		else
			_quake_ammo_icon = self.__quake_ammo_panel:bitmap({
				name = "_quake_ammo_icon",
				texture = "guis/textures/pd2/skilltree/icons_atlas",
				texture_rect = { 2 * 64, 0 * 64, 64, 64 },
				valign = "top",
				layer = 1,
				w = 64,
				h = 64
			})
		end
		_quake_ammo_icon:set_right(_quake_ammo_box:parent():w())
		_quake_ammo_icon:set_center_y(_quake_ammo_box:h() / 2)
		_quake_ammo_box:set_right(_quake_ammo_icon:left())
		
		self.__quake_ammo_panel:set_visible(true)
		
		_quake_ammo_icon:set_visible(false)
	end
		
	function HUDQUAKEAMMO:update(_current_clip, _current_left)
		_current_clip = math.clamp(_current_clip, 0, 999)
		_current_left = math.clamp(_current_left, 0, 999)
		self._text:set_text(string.format("%.f/%.f", _current_clip, _current_left))
		self._text:set_color(Color(1, 1, 1))
	end
	 
	Hooks:PostHook(HUDManager, "_setup_player_info_hud_pd2", "F_"..Idstring("PostHook:HUDManager:_setup_player_info_hud_pd2:HUDQUAKEAMMO:OwO"):key(), function(self)
		self._hud_quake_ammo = HUDQUAKEAMMO:new(managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2))
	end)
		
	function HUDManager:quake_ammo(_current_clip, _current_left)
		self._hud_quake_ammo:update(_current_clip, _current_left)
	end
	
elseif string.lower(RequiredScript) == "lib/units/beings/player/playerdamage" then
	Hooks:PostHook(PlayerDamage, "update", "F_"..Idstring("PostHook:PlayerDamage:update:HUDQUAKEAMMO:OwO"):key(), function(self)
		if managers.hud and managers.hud.quake_ammo and self._unit and self._unit:inventory() and self._unit:inventory():equipped_unit() then
			local _, _current_clip, _current_left, _ = self._unit:inventory():equipped_unit():base():ammo_info()
			managers.hud:quake_ammo(_current_clip, _current_left)
		end
	end)
end