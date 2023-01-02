if string.lower(RequiredScript) == "lib/managers/hudmanagerpd2" then
	HUDQUAKEDEPLOYABLE = HUDQUAKEDEPLOYABLE or class()

	function HUDQUAKEDEPLOYABLE:init(hud)
		self._hud_panel = hud.panel

		self.__quake_deployable_panel = self._hud_panel:panel({
			name = "_quake_deployable_counter_panel",
			visible = false,
			w = 400,
			h = 200
		})
		
		self.__quake_deployable_panel:set_bottom(self._hud_panel:h()-16)
		self.__quake_deployable_panel:set_right(self._hud_panel:w()-32)
			
		local _quake_deployable_box = HUDBGBox_create(self.__quake_deployable_panel, {w = 64, h = 64}, {})
		
		self._text = _quake_deployable_box:text({
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
			font_size = 32
		})
		

		local _quake_deployable_icon = self.__quake_deployable_panel:bitmap({
			name = "_quake_deployable_icon",
			texture = "guis/textures/pd2/skilltree/icons_atlas",
			texture_rect = { 2 * 64, 0 * 64, 64, 64 },
			valign = "top",
			layer = 1,
			w = 64,
			h = 64
		})
		_quake_deployable_icon:set_right(_quake_deployable_box:parent():w())
		_quake_deployable_icon:set_center_y(_quake_deployable_box:h() / 2)
		_quake_deployable_box:set_right(_quake_deployable_icon:left() - 8)
		
		self.__quake_deployable_panel:set_visible(true)
	end
		
	function HUDQUAKEDEPLOYABLE:update(_amount, _icon)
		if type(_icon) == "string" and self.__quake_deployable_panel and self.__quake_deployable_panel:child("_quake_deployable_icon") then
			local __texture, __texture_rect = tweak_data.hud_icons:get_icon_data(_icon, {
				0,
				0,
				32,
				32
			})
			if __texture and type(__texture_rect) == "table" then
				self.__quake_deployable_panel:child("_quake_deployable_icon"):set_image(__texture, unpack(__texture_rect))
			end
		end
		if type(_amount) == "number" then
			_amount = math.clamp(_amount, 0, 99)
			self._text:set_text(string.format("%.f", _amount))
			self._text:set_color(Color(1, 1, 1))		
		end
	end

	Hooks:PostHook(HUDManager, "_setup_player_info_hud_pd2", "F_"..Idstring("PostHook:HUDManager:_setup_player_info_hud_pd2:HUDQUAKEDEPLOYABLE:OwO"):key(), function(self)
		self._hud_quake_deployable = HUDQUAKEDEPLOYABLE:new(managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2))
	end)
		
	function HUDManager:quake_deployable(_amount, _icon)
		self._hud_quake_deployable:update(_amount, _icon)
	end

	Hooks:PostHook(HUDManager, "set_deployable_equipment", "F_"..Idstring("PostHook:PlayerDamage:set_deployable_equipment:HUDQUAKEDEPLOYABLE:OwO"):key(), function(self, i, data)
		if managers.hud and managers.hud.quake_deployable and type(data) == "table" and type(i) == type(HUDManager.PLAYER_PANEL) and i == HUDManager.PLAYER_PANEL then 
			managers.hud:quake_deployable(data.amount, data.icon)
		end
	end)

	Hooks:PostHook(HUDManager, "set_teammate_deployable_equipment_amount", "F_"..Idstring("PostHook:PlayerDamage:set_teammate_deployable_equipment_amount:HUDQUAKEDEPLOYABLE:OwO"):key(), function(self, i, index, data)
		if managers.hud and managers.hud.quake_deployable and type(data) == "table" and type(i) == type(HUDManager.PLAYER_PANEL) and i == HUDManager.PLAYER_PANEL then 
			managers.hud:quake_deployable(data.amount, data.icon)
		end
	end)
end