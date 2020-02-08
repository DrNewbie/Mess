local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local entries = {
	{ 'texture', 'units/lights/spot_light_projection_textures/', 'spotprojection_11_flashlight_df' }
}

for _, entry in ipairs(entries) do
	DB:create_entry(
		Idstring(entry[1]),
		Idstring(entry[2] .. entry[3]),
		string.format('%sassets/%s%s.%s', ModPath, entry[2], entry[3], entry[1])
	)
end
