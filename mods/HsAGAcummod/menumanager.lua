if not _G.HsAGA then
	_G.HsAGA = {}
	HsAGA.ModPath = ModPath
	HsAGA.SavePath = HsAGA.ModPath.."cfg/"
	HsAGA.HooksFunc = {
		item = {
			"choice_choose_texture_quality",
			"choice_choose_shadow_quality",
			"toggle_gpu_flush_setting",
			"choice_choose_anisotropic",
			"choice_fps_cap",
			"choice_choose_color_grading",
			"choice_choose_menu_theme",
			"choice_corpse_limit",
			"choice_choose_ao",
			"toggle_parallax",
			"choice_choose_aa",
			"toggle_workshop",
			"choice_choose_anti_alias",
			"choice_choose_anim_lod",
			"toggle_vsync",
			"toggle_use_thq_weapon_parts",
			"toggle_streaks",
			"toggle_light_adaption",
			"toggle_lightfx",
			"choice_max_streaming_chunk",
			"set_fov_multiplier",
			"set_fov_standard",
			"set_fov_zoom",
			"toggle_headbob",
			"toggle_adaptive_quality",
			"toggle_window_zoom",
			"toggle_arm_animation",
			"choice_choose_video_adapter",
			"set_brightness"
		}
	}
	HsAGA.CheckApply = {
		["choice_choose_texture_quality"] = {
			"RenderSettings",
			"texture_quality_default"
		},
		["choice_choose_shadow_quality"] = {
			"RenderSettings",
			"shadow_quality_default"
		},
		["choice_choose_anisotropic"] = {
			"RenderSettings",
			"max_anisotropy"
		}
	}
	
	function HsAGA:value()
		return self.apply_data_item
	end
	
	function HsAGA:Get_Apply_Data(apply_data)
		if apply_data.sp_type == "item" then
			self.apply_data_item = apply_data.data
			return self
		end
		return
	end
	
	function HsAGA:Apply_CFG(is_HsAGA, retry)
		if not managers.user or not MenuCallbackHandler or not managers.menu then
			return
		end
		local _save_file = nil
		if not is_HsAGA and Global.game_settings and Global.game_settings.level_id then
			_save_file = managers.job:current_job_id()..".json"	
		else
			_save_file = "def.ault.json"
		end
		if _save_file then
			local _cfg_file = io.open(self.SavePath.._save_file, "r")
			if not _cfg_file then
				
			else
				local _cfg_data = _cfg_file:read("*a")
				log("[HsAGA]:\t"..tostring(_save_file).."\t"..tostring(_cfg_data))
				 _cfg_data = json.decode(_cfg_data)
				_cfg_file:close()
				for func, apply_data in pairs(_cfg_data) do
					if table.contains(self.HooksFunc.item, func) then
						local Aans = self:Get_Apply_Data(apply_data)
						if Aans and self:value() then
							local __apply = true
							if self.CheckApply[func] then --don't need to re-apply
								local __v1 = self.CheckApply[func]
								if __v1[1] and __v1[1] == "RenderSettings" then
									if type(RenderSettings[__v1[2]]) == type(Aans:value()) and RenderSettings[__v1[2]] == Aans:value() then
										__apply = false
									end
								end
							end
							if __apply then
								MenuCallbackHandler[func](MenuCallbackHandler, Aans, true)
							end
						end
					end
				end
			end
		end
	end
	
	function HsAGA:Save_CFG(name, data, sp_type)
		local _save_file = nil
		if Utils and (Utils:IsInHeist() or Utils:IsInLoadingState() or Utils:IsInGameState()) and Global.game_settings and Global.game_settings.level_id then
			_save_file = Global.game_settings.level_id..".json"	
		else
			_save_file = "def.ault.json"
		end
		if _save_file then
			local _cfg_file = io.open(self.SavePath.._save_file, "r")
			if not _cfg_file then
				_cfg_file = io.open(self.SavePath.._save_file, "w+")
				local w_insert = {}
				w_insert[name] = {data = data, sp_type = sp_type}
				_cfg_file:write(json.encode(w_insert))
				_cfg_file:close()
			else
				local _cfg_data = json.decode(_cfg_file:read("*a"))
				_cfg_file:close()
				_cfg_file = io.open(self.SavePath.._save_file, "w+")
				_cfg_data[name] = {data = data, sp_type = sp_type}
				_cfg_file:write(json.encode(_cfg_data))
				_cfg_file:close()
			end
		end
	end
end

for sp_type, sp_data in pairs(HsAGA.HooksFunc) do
	for _, func in pairs(sp_data) do
		Hooks:PostHook(MenuCallbackHandler, func, "HsAGA_"..Idstring("Post:MenuCallbackHandler:"..func):key(), function(self, item, is_HsAGA)
			if not is_HsAGA then
				HsAGA:Save_CFG(func, item:value(), sp_type)
			end
		end)
	end
end

Hooks:Add('MenuManagerOnOpenMenu', 'HsAGA_RunInitNow', function(self, menu)
	if menu == 'menu_main' or menu == 'lobby' then
		DelayedCalls:Add('HsAGA_RunInitNow_Delay', 0.1, function()
			HsAGA:Apply_CFG(true)
		end)
	end
end)