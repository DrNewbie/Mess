Alt_BootupState = Alt_BootupState or class(BootupState)
if Alt_BootupState then
	log('lal')
	
	function Alt_BootupState:play_next(is_skipped)
		local res = RenderSettings.resolution
		local intro_trailer_layer = self._back_drop_gui:foreground_layers()
		
		self._play_time = TimerManager:game():time()
		self._play_index = math.random(1, 6)
		self._play_data_list = {}
		table.insert(self._play_data_list, {
			video = "movies/intro_trailer",
			can_skip = true,
			padding = 200,
			limit_file_streamer = true,
			layer = intro_trailer_layer,
			width = res.x,
			height = res.y
		})
		table.insert(self._play_data_list, {
			video = "movies/intro_trailer_1",
			can_skip = true,
			padding = 200,
			limit_file_streamer = true,
			layer = intro_trailer_layer,
			width = res.x,
			height = res.y
		})
		table.insert(self._play_data_list, {
			video = "movies/intro_trailer_2",
			can_skip = true,
			padding = 200,
			limit_file_streamer = true,
			layer = intro_trailer_layer,
			width = res.x,
			height = res.y
		})
		table.insert(self._play_data_list, {
			video = "movies/intro_trailer_3",
			can_skip = true,
			padding = 200,
			limit_file_streamer = true,
			layer = intro_trailer_layer,
			width = res.x,
			height = res.y
		})
		table.insert(self._play_data_list, {
			video = "movies/intro_trailer_4",
			can_skip = true,
			padding = 200,
			limit_file_streamer = true,
			layer = intro_trailer_layer,
			width = res.x,
			height = res.y
		})
		table.insert(self._play_data_list, {
			video = "movies/intro_trailer_5",
			can_skip = true,
			padding = 200,
			limit_file_streamer = true,
			layer = intro_trailer_layer,
			width = res.x,
			height = res.y
		})
		log(self._play_index)
		self._play_data = self._play_data_list[self._play_index]

		if is_skipped and self._play_data then
			while self._play_data and self._play_data.auto_skip do
				self._play_index = self._play_index + 1
				self._play_data = self._play_data_list[self._play_index]
			end
		end

		if self._play_data then
			if self._play_data.limit_file_streamer then
				managers.dyn_resource:set_file_streaming_chunk_size_mul(0.05, 10)

				self._limit_file_streamer = true
			elseif self._limit_file_streamer then
				managers.dyn_resource:set_file_streaming_chunk_size_mul(1, 3)

				self._limit_file_streamer = false
			end

			self._fade = self._play_data.fade_in and 0 or 1

			if alive(self._gui_obj) then
				self._panel:remove(self._gui_obj)

				if alive(self._gui_obj) then
					self._full_panel:remove(self._gui_obj)
				end

				self._gui_obj = nil
			end

			local res = RenderSettings.resolution

			if _G.IS_VR then
				res = Vector3(1280, 720, 0)
			end

			local width, height = nil
			local padding = self._play_data.padding or 0

			if self._play_data.gui then
				if self._play_data.width / self._play_data.height > res.x / res.y then
					width = res.x - padding * 2
					height = self._play_data.height * width / self._play_data.width
				else
					height = self._play_data.height
					width = self._play_data.width
				end
			else
				height = self._play_data.height
				width = self._play_data.width
			end

			local x = (self._panel:w() - width) / 2
			local y = (self._panel:h() - height) / 2
			local gui_config = {
				x = x,
				y = y,
				width = width,
				height = height,
				layer = tweak_data.gui.BOOT_SCREEN_LAYER
			}

			if self._play_data.video then
				gui_config.video = self._play_data.video
				gui_config.layer = self._play_data.layer or gui_config.layer
				self._gui_obj = self._full_panel:video(gui_config)

				self._gui_obj:set_volume_gain(1)

				if not managers.music:has_music_control() then
					self._gui_obj:set_volume_gain(0)
				end

				local w = self._gui_obj:video_width()
				local h = self._gui_obj:video_height()
				local m = h / w

				self._gui_obj:set_size(res.x, res.x * m)
				self._gui_obj:set_center(res.x / 2, res.y / 2)
				self._gui_obj:play()
			elseif self._play_data.texture then
				gui_config.texture = self._play_data.texture
				self._gui_obj = self._panel:bitmap(gui_config)
			elseif self._play_data.text then
				gui_config.text = self._play_data.text
				gui_config.font = self._play_data.font
				gui_config.font_size = self._play_data.font_size
				gui_config.wrap = self._play_data.wrap
				gui_config.word_wrap = self._play_data.word_wrap
				gui_config.vertical = self._play_data.vertical
				self._gui_obj = self._panel:text(gui_config)
			elseif self._play_data.gui then
				self._gui_obj = self._panel:gui(self._play_data.gui)

				self._gui_obj:set_shape(x, y, width, height)

				local script = self._gui_obj:script()

				if script.setup then
					script:setup()
				end
			end

			self:apply_fade()
		else
			self:gsm():change_state_by_name("menu_titlescreen")
		end
	end
	
	Alt_BootupState:at_enter()
end
log('lua')