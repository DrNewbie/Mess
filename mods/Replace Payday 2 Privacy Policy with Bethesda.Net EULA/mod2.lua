local __ids_key = Idstring("Replace Payday 2 Privacy Policy with Bethesda.Net EULA"):key()

if _G[__ids_key] then
	return
else
	_G[__ids_key] = ModPath
end

core:module("SystemMenuManager")
core:import("CoreTable")
require("lib/managers/dialogs/Dialog")
require("lib/managers/menu/ExtendedUiElemets")
require("lib/managers/menu/BoxGuiObject")
require("lib/utils/gui/FineText")

function DocumentDialog:_create_text_data(data, ...)
	if data.file_name == "telemetry" then
		local tweak_data = _G.tweak_data
		local text_data = {
			title = data.title and utf8.to_upper(data.title) or "",
			text = {}
		}
		local _file = io.open(_G[__ids_key].."BethesdaNetEULA.json", "r")
		if not _file then
			return text_data
		end
		local list = json.decode(tostring(_file:read("*all")))
		_file:close()
		local font, font_size, color, link, bullet = nil
		for _idx, data in pairs(list) do
			if data._meta == "text" then
				font = tweak_data.menu.pd2_small_font
				font_size = tweak_data.menu.pd2_small_font_size
				color = Color(1, 0.9, 0.9, 0.9)
				link, bullet = nil
				if data.type == "topic" then
					font = tweak_data.menu.pd2_medium_font
					font_size = tweak_data.menu.pd2_medium_font_size
					color = tweak_data.screen_colors.text
				elseif data.type == "hyperlink" then
					color = tweak_data.screen_colors.button_stage_2
					link = data.link
				elseif data.type == "bullet" then
					bullet = true
				end
				table.insert(text_data.text, {
					wrap = true,
					word_wrap = true,
					text = data.text,
					font = font,
					font_size = font_size,
					color = color,
					link = link,
					bullet = bullet,
					_idx = _idx
				})
			elseif data._meta == "br" then
				table.insert(text_data.text, {
					padding = data.size and tonumber(data.size) or 26,
					_idx = _idx
				})
			end
		end
		table.sort(text_data.text, function(a, b)
			return a._idx < b._idx
		end)
		return text_data
	end
	return __old_DocumentDialog_create_text_data(self, data, ...)
end