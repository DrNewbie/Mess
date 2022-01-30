local function OptChanged()
	local ThisModPath = "mods/Invisible Enemies Alt/"
	--os.execute('RD "'.. Application:nice_path(ThisModPath..'/Assets/', true) ..'" /S /Q')
	local __main_xml = io.open(ThisModPath..'/main.xml', "w+")
	if __main_xml then
		__main_xml:write('<table name="FFTestt"> \n')
		__main_xml:write('	<AddFiles directory="Assets"> \n')
		__main_xml:write('		<texture path="guis/invisible_texture" force="true"/> \n')
		local char_map = tweak_data.character.character_map()
		for _, __table in pairs(char_map) do
			if type(__table) == "table" and type(__table.path) == "string" and type(__table.list) == "table" then
				for _, __u_name in pairs(__table.list) do
					local unit_dir = __table.path .. tostring(__u_name)
					local unit_path = __table.path .. tostring(__u_name) .. "/" .. tostring(__u_name)
					unit_path = tostring(unit_path)
					if blt.asset_db.has_file(unit_path, "material_config") then
						local __xml = tostring( blt.asset_db.read_file(unit_path, "material_config") )
						if __xml and __xml:find("RL_COPS") then
							os.execute('mkdir "'.. Application:nice_path(ThisModPath..'/Assets/'..unit_dir, true) ..'"')
							__xml = __xml:gsub('SKINNED_3WEIGHTS', 'SKINNED_3WEIGHTS:GHOST')
							local material_config_xml_file = io.open(ThisModPath..'/Assets/'..unit_path..'.material_config', "w+")
							material_config_xml_file:write(__xml)
							material_config_xml_file:close()
							__main_xml:write('		<material_config path="'..unit_path..'" force="true"/> \n')
						end
					end
				end
			end
		end
		__main_xml:write('	</AddFiles> \n')
		__main_xml:write('</table> \n')
		__main_xml:close()
	end
end

OptChanged()