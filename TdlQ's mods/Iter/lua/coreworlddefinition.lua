local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

core:module('CoreWorldDefinition')

local level_id = _G.Iter:get_level_id()

local itr_original_worlddefinition_createstaticsunit = WorldDefinition._create_statics_unit

if not _G.Iter.settings['map_change_' .. level_id] then
	-- qued

elseif level_id == 'mia_1' then

	function WorldDefinition:_create_statics_unit(data, offset)
		local unit_id = data.unit_data.unit_id
		if unit_id == 101331 then -- room 104
			mvector3.add(data.unit_data.position, Vector3(0, 20, 0))
		elseif unit_id == 101333 then -- room 105
			mvector3.add(data.unit_data.position, Vector3(0, 20, 0))
		elseif unit_id == 101334 then -- room 106
			mvector3.add(data.unit_data.position, Vector3(0, 20, 0))
		end

		return itr_original_worlddefinition_createstaticsunit(self, data, offset)
	end

elseif level_id == 'mad' then

	function WorldDefinition:_create_statics_unit(data, offset)
		local unit_id = data.unit_data.unit_id
		if unit_id == 136936 or unit_id == 136937 then
			mvector3.add(data.unit_data.position, Vector3(40, 0, 0))
		end

		return itr_original_worlddefinition_createstaticsunit(self, data, offset)
	end

elseif level_id == 'wwh' then

	function WorldDefinition:_create_statics_unit(data, offset)
		local unit = itr_original_worlddefinition_createstaticsunit(self, data, offset)
		if unit then
			if data.unit_data.unit_id == 100139 or data.unit_data.unit_id == 100142 then
				unit:body(0):set_fixed(true)
			end
		end
		return unit
	end

elseif level_id == 'mex' then

	function WorldDefinition:_create_statics_unit(data, offset)
		if data.unit_data.unit_id == 147353 then
			mvector3.add(data.unit_data.position, Vector3(20, 0, 0))
		end

		return itr_original_worlddefinition_createstaticsunit(self, data, offset)
	end

elseif level_id == 'firestarter_1' then

	function WorldDefinition:_create_statics_unit(data, offset)
		if data.unit_data.unit_id == 102765 then
			return -- no spot => no glow
		end

		local unit = itr_original_worlddefinition_createstaticsunit(self, data, offset)

		if not unit then
			-- qued
		elseif data.unit_data.unit_id == 103986 then
			unit:set_position(Vector3(-5650.42, 5586.73, 2088.54))
			unit:material(Idstring('light_cone')):set_variable(Idstring('intensity'), 0.1)
		elseif data.unit_data.unit_id == 103980 then
			unit:set_position(Vector3(1449, 5790, 789))
		end

		return unit
	end

elseif level_id == 'dah' then

	if Network:is_server() then
		function WorldDefinition:_create_statics_unit(data, offset)
			local unit = itr_original_worlddefinition_createstaticsunit(self, data, offset)

			if unit and data.unit_data.unit_id == 704208 then
				unit:set_position(Vector3(-2518, -5029, 54))
			end

			return unit
		end
	end

	local itr_original_worlddefinition_create = WorldDefinition.create
	function WorldDefinition:create(layer, offset)
		if layer == 'all' then
			self._definition.portal.unit_groups = {
				group1 = {
					ids = {
						[102355] = true,
						[703925] = true,
						[701893] = true,
						[702351] = true,
						[703949] = true,
						[701863] = true,
						[702073] = true,
						[701895] = true,
						[704113] = true,
						[703930] = true,
						[704028] = true,
						[701518] = true,
						[704027] = true,
						[704018] = true,
						[704003] = true,
						[701711] = true,
						[704001] = true,
						[701884] = true,
						[701479] = true,
						[703933] = true,
						[702961] = true,
						[701185] = true,
						[701511] = true,
						[703932] = true,
						[102353] = true,
						[102354] = true,
					},
					shapes = {
						{
							rotation = Rotation(0, 0, -0),
							position = Vector3(-4678, -5400, 367.26),
							type = 'box',
							width = 2467,
							depth = 2009,
							height = 360,
						}
					}
				},
				group2 = {
					ids = {
						[701042] = true,
					},
					shapes = {
						{
							rotation = Rotation(0, 0, -0),
							position = Vector3(-5981, -5402, 373),
							type = 'box',
							width = 1510,
							depth = 1431,
							height = 2000,
						},
						{
							rotation = Rotation(0, 0, -0),
							position = Vector3(-6564, -4100, 1162),
							type = 'box',
							width = 1746,
							depth = 2700,
							height = 420,
						}
					},
				},
				group3 = {
					ids = {
						[702001] = true,
						[701226] = true,
						[701042] = true,
						[701496] = true,
						[701405] = true,
					},
					shapes = {
						{
							rotation = Rotation(0, 0, -0),
							position = Vector3(-6000, -5400, 765.001),
							type = 'box',
							width = 4721,
							depth = 2521,
							height = 650,
						}
					},
				},
				group4 = {
					ids = {},
					shapes = {
						{
							rotation = Rotation(-90, 0, -0),
							position = Vector3(-5700, -300, 770.001),
							type = 'box',
							width = 5284,
							depth = 5310,
							height = 1220,
						}
					},
				},
				group5 = {
					ids = {
						[600431] = true,
						[702277] = true,
						[700457] = true,
					},
					shapes = {
						{
							rotation = Rotation(4.00716e-005, -0, -0),
							position = Vector3(-6622, -3350, 771.933),
							type = 'box',
							width = 5200,
							depth = 1620,
							height = 1000,
						},
						{
							rotation = Rotation(0, 0, -0),
							position = Vector3(-6618, -2831, 775.001),
							type = 'box',
							width = 1000,
							depth = 4452,
							height = 390,
						}
					},
				},
				group6 = {
					ids = {
						[702247] = true,
						[702176] = true,
						[702213] = true,
						[702248] = true,
						[702175] = true,
					},
					shapes = {
						{
							rotation = Rotation(0, 0, -0),
							position = Vector3(-6639, -2900, 748.001),
							type = 'box',
							width = 6697,
							depth = 4423,
							height = 1000,
						}
					},
				},
				group7 = {
					ids = {
						[701576] = true,
						[700754] = true,
						[702640] = true,
						[700792] = true,
						[700753] = true,
						[144980] = true,
						[144981] = true,
						[144983] = true,
						[700751] = true,
						[700730] = true,
						[700096] = true,
						[700654] = true,
						[144982] = true,
						[700182] = true,
						[700091] = true,
						[700116] = true,
					},
					shapes = {
						{
							rotation = Rotation(-180, 0, -0),
							position = Vector3(11, 1509, 774.001),
							type = 'box',
							width = 2760,
							depth = 5754,
							height = 1000,
						}
					},
				},
				group8 = {
					ids = {},
					shapes = {
						{
							rotation = Rotation(2.00359e-005, -0, -0),
							position = Vector3(-6615, -3800, 348),
							type = 'box',
							width = 2421,
							depth = 5338,
							height = 405,
						}
					},
				},
				group9 = {
					ids = {
						[700154] = true,
					},
					shapes = {
						{
							rotation = Rotation(-180, 0, -0),
							position = Vector3(6.99997, 1524, 371.242),
							type = 'box',
							width = 2380,
							depth = 4893,
							height = 360,
						}
					},
				},
				group10 = {
					ids = {
						[700154] = true,
						[700084] = true,
						[700032] = true,
						[700072] = true,
					},
					shapes = {
						{
							rotation = Rotation(-180, 0, -0),
							position = Vector3(-0.000195503, 2200, 214.242),
							type = 'box',
							width = 6610,
							depth = 2724,
							height = 959,
						}
					},
				},
				group11 = {
					ids = {},
					shapes = {
						{
							rotation = Rotation(-180, 0, -0),
							-- position = Vector3(0, -1800, 373),
							position = Vector3(0, -1250, 373),
							type = 'box',
							width = 6615,
							-- depth = 2400,
							depth = 2950,
							height = 369,
						}
					},
				},
				group12 = {
					ids = {},
					shapes = {
						{
							rotation = Rotation(-90, 0, -0),
							position = Vector3(-6611, 2205, 163),
							type = 'box',
							width = 1367,
							depth = 6659,
							height = 1558,
						}
					},
				},
				group13 = {
					ids = {
						[102873] = true,
						[703100] = true,
						[100676] = true,
						[102574] = true,
						[102989] = true,
						[102990] = true,
						[100083] = true,
						[700088] = true,
						[101455] = true,
						[700082] = true,
						[100087] = true,
						[104194] = true,
						[104193] = true,
						[104192] = true,
						[104191] = true,
					},
					shapes = {
						{
							rotation = Rotation(0, 0, -0),
							position = Vector3(-5300, -6688, -284),
							type = 'box',
							width = 3933,
							depth = 4181,
							height = 590,
						}
					},
				},
				group14 = {
					ids = {
						[104016] = true,
						[104017] = true,
						[104018] = true,
						[102991] = true,
						[702122] = true,
						[703084] = true,
						[104189] = true,
						[100675] = true,
						[100174] = true,
						[100583] = true,
						[700035] = true,
						[703041] = true,
						[702123] = true,
						[104190] = true,
						[100089] = true,
						[104359] = true,
						[104360] = true,
						[100088] = true,
						[104317] = true,
					},
					shapes = {
						{
							rotation = Rotation(180, 0, -0),
							position = Vector3(-2338, -354, 25),
							type = 'box',
							width = 1920,
							depth = 1496,
							height = 720,
						},
						{
							rotation = Rotation(-90, 0, -0),
							position = Vector3(-5350, -1801, -323),
							type = 'box',
							width = 4888,
							depth = 4132,
							height = 663,
						}
					},
				},
				group15 = {
					ids = {
						[143950] = true,
						[142963] = true,
						[142965] = true,
						[143923] = true,
						[135102] = true,
						[135108] = true,
						[135110] = true,
						[135174] = true,
						[143910] = true,
						[143945] = true,
						[143947] = true,
						[142964] = true,
						[142966] = true,
						[703388] = true,
						[703815] = true,
						[703389] = true,
						[703387] = true,
						[143978] = true,
						[143953] = true,
						[135173] = true,
						[135175] = true,
						[143944] = true,
						[143946] = true,
						[135115] = true,
					},
					shapes = {
						{
							rotation = Rotation(0, 0, -0),
							position = Vector3(-6643, -5457, 58.0001),
							type = 'box',
							width = 7078,
							depth = 7630,
							height = 1000,
						}
					}
				}
			}
		end

		return itr_original_worlddefinition_create(self, layer, offset)
	end

elseif level_id == 'chill_combat' then

	local itr_original_worlddefinition_serializetoscript = WorldDefinition._serialize_to_script
	function WorldDefinition:_serialize_to_script(...)
		local result = itr_original_worlddefinition_serializetoscript(self, ...)

		local instances = result.instances
		if instances then
			for i = #instances, 1, -1 do
				local instance = instances[i]
				if _G.Iter.delete_instances[instance.name] then
					table.remove(instances, i)
				end
			end
		end

		return result
	end

	local _spare_units = {
		['units/pd2_dlc_chill/props/chl_prop_jimmy_barstool/chl_prop_jimmy_barstool_v2'] = true,
		['units/pd2_dlc_chill/props/chl_props_trophy_shelf/chl_props_trophy_shelf'] = true,
		['units/pd2_dlc_friend/props/sfm_prop_office_door_whole_black/sfm_prop_office_door_whole_black'] = true,
		['units/pd2_dlc_chill/props/chl_prop_livingroom_coffeetable_b/chl_prop_livingroom_coffeetable_b'] = true,
	}

	local function _is_ok(name, pos)
		local x, y, z = pos.x, pos.y, pos.z
		if name == 'units/dev_tools/level_tools/shadow_caster_10x10' and x - 524.999 < 0.01 and y == 2025 and z == -25 then
			-- otherwise light near Sydney's place
		elseif name == 'units/payday2/architecture/ind/ind_ext_level/ind_ext_fence_pole_2m_grey' and x == -392 and y == -386 and z == -45 then
			-- qued
		elseif not _spare_units[name] then
			if z < -10 then
				if x > 200 and x < 825 and y >= -1500 and y < -1000 then
					-- stairs to lower levels
				elseif x > 230 and x < 1600 and y > -864 and y < 0 then
					-- vault visible through floor window
				else
					return false
				end
			elseif x > 825 and x < 1202 and y > 427 and y < 775 and z > -4 and z < 291 then
				-- bathroom
				return false
			elseif x > 815 and x < 1200 and y > 1220 and y < 1575 and z > 380 and z < 689 then
				-- bathroom
				return false
			elseif x > 1200 and y > 800 then
				return false
			end
		end
		return true
	end

	function WorldDefinition:create_delayed_unit(new_unit_id)
		local spawn_data = self._delayed_units[new_unit_id]
		if spawn_data then
			local unit_data = spawn_data[1]
			if not unit_data.position or _is_ok(unit_data.name, unit_data.position) then
				PackageManager:load_delayed('unit', unit_data.name)
				self:preload_unit(unit_data.name)
				local unit = self:make_unit(unit_data, spawn_data[2])
				if unit then
					unit:set_spawn_delayed(true)
					table.insert(spawn_data[3], unit)
				end
			end
		end
	end

	function WorldDefinition:_create_statics_unit(data, offset)
		local pos = data.unit_data.position
		if not pos or _is_ok(data.unit_data.name, pos) then
			return itr_original_worlddefinition_createstaticsunit(self, data, offset)
		end
	end

end
