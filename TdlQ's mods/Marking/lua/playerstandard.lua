local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

_G.Marking = Marking or {}
Marking.path = ModPath
Marking.data_path = SavePath .. 'marking.txt'
Marking.settings = {
	mark_aim = false,
	ignore_disabled_cams = true,
	prioritize_intimidated = true,
}

function Marking:Load()
	local file = io.open(self.data_path, 'r')
	if file then
		for k, v in pairs(json.decode(file:read('*all')) or {}) do
			self.settings[k] = v
		end
		file:close()
	end
end

function Marking:Save()
	local file = io.open(self.data_path, 'w+')
	if file then
		file:write(json.encode(self.settings))
		file:close()
	end
end

Marking:Load()

Hooks:Add('LocalizationManagerPostInit', 'LocalizationManagerPostInit_Marking', function(loc)
	local language_filename

	local modname_to_language = {
		['PAYDAY 2 THAI LANGUAGE Mod'] = 'thai.txt',
	}
	for _, mod in pairs(BLT and BLT.Mods:Mods() or {}) do
		language_filename = mod:IsEnabled() and modname_to_language[mod:GetName()]
		if language_filename then
			break
		end
	end

	if not language_filename then
		for _, filename in pairs(file.GetFiles(Marking.path .. 'loc/')) do
			local str = filename:match('^(.*).txt$')
			if str and Idstring(str) and Idstring(str):key() == SystemInfo:language():key() then
				language_filename = filename
				break
			end
		end
	end

	if language_filename then
		loc:load_localization_file(Marking.path .. 'loc/' .. language_filename)
	end
	loc:load_localization_file(Marking.path .. 'loc/english.txt', false)
end)

Hooks:Add('MenuManagerInitialize', 'MenuManagerInitialize_Marking', function(menu_manager)
	MenuCallbackHandler.MarkingMenuCheckboxClbk = function(this, item)
		Marking.settings[item:name()] = item:value() == 'on'
	end

	MenuCallbackHandler.MarkingSave = function(this, item)
		Marking:Save()
	end

	MenuHelper:LoadFromJsonFile(Marking.path .. 'menu/options.txt', Marking, Marking.settings)
end)

local mrk_original_playerstandard_getinteractiontarget = PlayerStandard._get_interaction_target
function PlayerStandard:_get_interaction_target(char_table, ...)
	local settings = Marking.settings
	for i = #char_table, 1, -1 do
		local item = char_table[i]
		local unit_type = item.unit_type

		if unit_type == 0 and settings.prioritize_intimidated then -- unit_type_enemy
			local anim_data = item.unit:anim_data()
			if anim_data.hands_up or anim_data.hands_back then
				item.inv_wgt = item.inv_wgt * 0.5
			end

		elseif unit_type == 3 and settings.ignore_disabled_cams then -- unit_type_camera
			if type(item.unit.interaction) == 'function' and type(item.unit:interaction()) == 'table' and item.unit:interaction():active() then
				-- qued
			else
				table.remove(char_table, i)
			end
		end
	end

	return mrk_original_playerstandard_getinteractiontarget(self, char_table, ...)
end

if Marking.settings.mark_aim then
	function PlayerStandard:_add_unit_to_char_table(char_table, unit, unit_type, interaction_dist, interaction_through_walls, tight_area, priority, my_head_pos, cam_fwd, ray_ignore_units, ray_types)
		if unit:unit_data().disable_shout and not unit:brain():interaction_voice() then
			return
		end

		local u_head_pos = unit_type == 3 and unit:base():get_mark_check_position() or unit:movement():m_head_pos() + math.UP * 30
		local vec = u_head_pos - my_head_pos
		local dis = mvector3.normalize(vec)
		local max_dis = interaction_dist
		if dis < max_dis then
			local max_angle = math.max(8, math.lerp(tight_area and 30 or 90, tight_area and 10 or 30, dis / 1200))
			local angle = vec:angle(cam_fwd)
			if angle < max_angle then
				if interaction_through_walls then
					table.insert(char_table, {
						unit = unit,
						inv_wgt = angle,
						unit_type = unit_type
					})
				else
					local ray = World:raycast('ray', my_head_pos, u_head_pos, 'slot_mask', self._slotmask_AI_visibility, 'ray_type', ray_types or 'ai_vision', 'ignore_unit', ray_ignore_units or {})
					if not ray or mvector3.distance_sq(ray.position, u_head_pos) < 900 then
						table.insert(char_table, {
							unit = unit,
							inv_wgt = angle,
							unit_type = unit_type
						})
					end
				end
			end
		end
	end
end
