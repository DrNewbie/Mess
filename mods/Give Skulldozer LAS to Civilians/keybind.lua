local __attach_line = [[
		<extension name="spawn_manager" class="ManageSpawnedUnits" >
			<var name="is_cop" value="true"/>
			<var name="_char_joint_names" type="table" >
				<var value="root_point" />
				<var value="Hips" />
				<var value="Spine" />
				<var value="Spine1" />
				<var value="Spine2" />
				<var value="Neck" />
				<var value="Head" />
				
				<var value="LeftShoulder" />
				<var value="LeftArm" />
				<var value="LeftForeArmRoll" />
				<var value="LeftForeArm" />
				<var value="LeftHand" />

				<var value="LeftHandThumb1" />
				<var value="LeftHandThumb2" />
				<var value="LeftHandThumb3" />

				<var value="LeftHandIndex1" />
				<var value="LeftHandIndex2" />
				<var value="LeftHandIndex3" />

				<var value="LeftHandMiddle1" />
				<var value="LeftHandMiddle2" />
				<var value="LeftHandMiddle3" />

				<var value="LeftHandRing1" />
				<var value="LeftHandRing2" />
				<var value="LeftHandRing3" />

				<var value="LeftHandPinky1" />
				<var value="LeftHandPinky2" />
				<var value="LeftHandPinky3" />

				<var value="RightShoulder" />
				<var value="RightArm" />
				<var value="RightForeArmRoll" />
				<var value="RightForeArm" />
				<var value="RightHand" />

				<var value="RightHandThumb1" />
				<var value="RightHandThumb2" />
				<var value="RightHandThumb3" />

				<var value="RightHandIndex1" />
				<var value="RightHandIndex2" />
				<var value="RightHandIndex3" />

				<var value="RightHandMiddle1" />
				<var value="RightHandMiddle2" />
				<var value="RightHandMiddle3" />

				<var value="RightHandRing1" />
				<var value="RightHandRing2" />
				<var value="RightHandRing3" />

				<var value="RightHandPinky1" />
				<var value="RightHandPinky2" />
				<var value="RightHandPinky3" />

				<var value="LeftUpLeg" />
				<var value="LeftLeg" />
				<var value="LeftFoot" />
				<var value="LeftToeBase" />

				<var value="RightUpLeg" />
				<var value="RightLeg" />
				<var value="RightFoot" />
				<var value="RightToeBase" />
			</var>
			<var name="allow_client_spawn" value="true"/>
			<var name="local_only" value="true"/>
		</extension>
]]

local function OptChanged()
	local ThisModPath = "mods/Give Skulldozer LAS to Civilians/"
	os.execute('RD "'.. Application:nice_path(ThisModPath..'/xml/', true) ..'" /S /Q')
	os.execute('MD "'.. Application:nice_path(ThisModPath..'/xml/', true))
	local __main_xml = io.open(ThisModPath..'/lua/read_assets.lua', "w+")
	if __main_xml then
		__main_xml:write('local ThisModPath = ModPath \n')
		__main_xml:write('local function ReadThisModAssets()\n')
		local char_map = tweak_data.character.character_map()
		local Done = {}
		local Block = {
			--ene_medic_r870 = true,
			--ene_female_civ_undercover = true
		}
		for _, __table in pairs(char_map) do
			if type(__table) == "table" and type(__table.path) == "string" and type(__table.list) == "table" then
				for _, __u_name in pairs(__table.list) do
					__u_name = tostring(__u_name)
					local unit_dir = __table.path .. __u_name
					local unit_path = __table.path .. __u_name .. "/" .. __u_name
					unit_path = tostring(unit_path)
					local u_key = Idstring(unit_path):key()
					if not Block[__u_name] and not Done[u_key] then
						Done[u_key] = true
						if blt.asset_db.has_file(unit_path, "unit") and blt.asset_db.has_file(unit_path, "object") then
							local __o_xml = tostring(blt.asset_db.read_file(unit_path, "unit"))
							if not __o_xml:find("spawn_manager") and __o_xml:find("CivilianBase") then
								local __s_xml = io.open(ThisModPath..'/xml/'..u_key..'.unit', "w+")
								if __s_xml then
									__main_xml:write('	BLTAssetManager:CreateEntry(\n')
									__main_xml:write('		Idstring("'..unit_path..'"),\n')
									__main_xml:write('		Idstring("unit"),\n')
									__main_xml:write('		ThisModPath.."xml/'..u_key..'.unit",\n')
									__main_xml:write('		nil\n')
									__main_xml:write('	)\n')
									for __line in __o_xml:gmatch("([^\n]*)\n?") do
										__s_xml:write(__line..'\n')
										if __line:find('<extensions>') then
											__s_xml:write(''..__attach_line..'\n')
										end
									end
									__s_xml:close()
								end
							end
						end
					end
				end
			end
		end
		__main_xml:write('end\n')
		__main_xml:write('ReadThisModAssets()\n')
		__main_xml:close()
	end
end

OptChanged()