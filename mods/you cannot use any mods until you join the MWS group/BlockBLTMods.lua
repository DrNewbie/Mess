local ThisModPath = tostring(ModPath)

Hooks:Add('MenuManagerOnOpenMenu', 'BuyMWSDLCPLSDONOWOWOCALLMENOW', function(self, menu)
	if menu == 'menu_main' or menu == 'lobby' then
		local IS_MWS_DLC
		if not managers.dlc or not managers.dlc.is_dlc_unlocked then
		
		else
			IS_MWS_DLC = managers.dlc:is_dlc_unlocked("mws_group")
		end
		local forced_reload
		if BLT and BLT.Mods and BLT.Mods then
			for id, mod in pairs(BLT.Mods:Mods()) do
				if mod:IsEnabled() and mod:CanBeDisabled() then
					if ThisModPath ~= mod:GetPath() then
						if not IS_MWS_DLC then
							forced_reload = true
							mod:SetEnabled(false, true)
						end
					else
						mod.json_data.name = tostring(Idstring(tostring(os.time())):key()..Idstring(tostring(math.random())):key())
						mod.json_data.name = mod.json_data.name:upper()
						local _file = io.open(mod:GetPath().."mod.txt", "w+")
						if _file then
							_file:write(tostring(json.encode(mod.json_data)))
							_file:close()
						end
					end
				end
			end
		end
		if forced_reload then
			BLT.Mods:Save()
			DelayedCalls:Add('BuyMWSDLCPLSDONOWOWO', 1, function()
				if setup and setup.load_start_menu then
					setup:load_start_menu()
				end
			end)
		end
	end
end)