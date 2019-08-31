Hooks:Add("LocalizationManagerPostInit", "CheckRoFBuffMod", function()
	if io.file_is_readable('mods/RoFBuffMod/mod.txt') then
	
	else
		os.execute('mkdir "'.. Application:nice_path(Application:base_path()..'mods/RoFBuffMod/', true) ..'"')
		local ff = io.open('mods/RoFBuffMod/main.xml', 'w+')
		if ff then
			ff:write('<table name="RoFBuffMod"> <AssetUpdates id="24788" version="0" provider="modworkshop" use_local_dir="true" use_local_path="true"/> </table>')
			ff:close()
			if ModCore then
				ModCore:new('mods/RoFBuffMod/main.xml', true, true)
			end
		end
	end
end)