local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

if Global.game_settings and Global.game_settings.level_id:find('welcome_to_the_jungle_2') then
	local entries = {
		{ 'unit', 'units/payday2/props/gen_prop_lab_clipboards/', 'gen_prop_lab_clipboard' },
		{ 'unit', 'units/payday2/props/gen_prop_lab_notebooks/', 'gen_prop_lab_notebooks' }
	}

	for _, entry in ipairs(entries) do
		DB:create_entry(
			Idstring(entry[1]),
			Idstring(entry[2] .. entry[3]),
			string.format('%sassets/%s%s.%s', ModPath, entry[2], entry[3], entry[1])
		)
	end
end
