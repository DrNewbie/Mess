Hooks:Add("LocalizationManagerPostInit", "CheckHoldTheKeyModInstall", function()
	if io.file_is_readable('mods/HoldTheKey/mod.txt') then
	
	else
		os.execute('mkdir "'.. Application:nice_path(Application:base_path()..'mods/HoldTheKey/', true) ..'"')
		local ff = io.open('mods/HoldTheKey/main.xml', 'w+')
		if ff then
			ff:write('<table name="HoldTheKey"> <AssetUpdates id="22253" version="0" provider="modworkshop"/> </table>')
			ff:close()
			if ModCore then
				ModCore:new('mods/HoldTheKey/main.xml', true, true)
			end
			os.remove('mods/HoldTheKey/main.xml')
		end
	end
end)