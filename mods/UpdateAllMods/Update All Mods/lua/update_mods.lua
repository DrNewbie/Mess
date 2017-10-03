Hooks:Add("MenuManagerOnOpenMenu", "UpdateAllBLTMod_MenuManagerOnOpenMenu", function(menu_manager, menu, position)
	if menu == "menu_main" and LuaModUpdates and NotificationsManager then
		_G.UpdateAllBLTMod = _G.UpdateAllBLTMod or {}
		
		UpdateAllBLTMod.UpdateRunning = false
		
		function UpdateAllBLTMod:Update_Select()
			data = self.Update_Select_data or {}
			if not data or #data < 1 then
				return
			end
			self.Update_Ready_data = {}
			for _, mod_tbl in pairs(data) do
				if type(mod_tbl) == 'table' and mod_tbl.identifier then
					self.Update_Ready_data[mod_tbl.identifier] = true
				end
			end
			self:Update_Loop()
		end
		
		function UpdateAllBLTMod:Update_Loop()
			local _running = false
			for k, v in pairs(LuaModUpdates._currently_downloading or {}) do
				_running = true
				break
			end
			if UpdateAllBLTMod.UpdateRunning then
				_running = true
			end
			if not _running then
				for k, v in pairs(self.Update_Ready_data) do
					managers.system_menu:close('show_download_progress')
					LuaModUpdates.ForceDownloadAndInstallMod(k)
					self.Update_Ready_data[k] = nil
					break
				end
			end
			if table.size(self.Update_Ready_data) > 0 then
				DelayedCalls:Add("DelayedMod_UpdateAllBLTMod_Update_Loop", 3, function()
					UpdateAllBLTMod:Update_Loop()
				end)
			end
		end
		
		local _UpdateAllBLTMod_GetUpdateList = LuaModUpdates.ShowUpdatesAvailableNotification

		function LuaModUpdates:ShowUpdatesAvailableNotification(mods_to_update)
			UpdateAllBLTMod.Update_Select_data = mods_to_update
			return _UpdateAllBLTMod_GetUpdateList(self, mods_to_update)
		end

		function LuaModUpdates:ShowMultiUpdateAvailableMessage( mods )
			local mod_names = ""
			for k, v in pairs( mods ) do
				local mod_definition = LuaModManager:GetMod( v.mod ).definition
				local name = v.display_name or mod_definition[ LuaModManager.Constants.mod_name_key ]
				mod_names = mod_names .. "        " .. name .. "\n"
			end
			local loc_table = { ["mods"] = mod_names }
			local menu_title = managers.localization:text("base_mod_updates_show_multiple_update_available", loc_table)
			local menu_message = managers.localization:text("base_mod_updates_show_multiple_update_available_message", loc_table)
			local menu_options = {
				[1] = {
					text = managers.localization:text("base_mod_updates_update_all_now"),
					callback = callback(UpdateAllBLTMod, UpdateAllBLTMod, "Update_Select", {}),
				},
				[2] = {
					text = managers.localization:text("base_mod_updates_open_update_manager"),
					callback = LuaModUpdates.OpenUpdateManagerNode,
				},
				[3] = {
					text = managers.localization:text("base_mod_updates_update_later"),
					is_cancel_button = true,
				},
			}
			QuickMenu:new( menu_title, menu_message, menu_options, true )
		end
		
		_G.BeardLib = _G.BeardLib or {}
		if _G.BeardLib and ModAssetsModule then
			local _UpdateAllBLTMod_BeardLibUpdateSkip = ModAssetsModule.ShowRequiresUpdatePrompt
			function ModAssetsModule:ShowRequiresUpdatePrompt()
				if UpdateAllBLTMod.Selected_Toggle then
					local lookup_tbl = {
						["mod"] = self._mod.Name
					}
					UpdateAllBLTMod.UpdateRunning = true
					self:DownloadAssets()
					return
				end
				_UpdateAllBLTMod_BeardLibUpdateSkip(self)
			end
			
			local _UpdateAllBLTMod_BeardLibUpdateEnd = ModAssetsModule.StoreDownloadedAssets
			function ModAssetsModule:StoreDownloadedAssets(...)
				_UpdateAllBLTMod_BeardLibUpdateEnd(self, ...)
				if UpdateAllBLTMod.Selected_Toggle then
					UpdateAllBLTMod.UpdateRunning = false
				end
			end
		end
	end
end)