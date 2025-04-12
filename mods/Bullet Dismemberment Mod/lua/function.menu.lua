local ThisModPath = tostring(ModPath)
local ThisModIds = Idstring(ThisModPath):key()

local __Name = function(__id)
	return "K_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end

BulletDecapitations = BulletDecapitations or {}

BulletDecapitations._data = BulletDecapitations._data or {}

Hooks:Add("LocalizationManagerPostInit", __Name(1), function(loc)
	loc:load_localization_file(ThisModPath.."loc.english.txt", false)
end)

Hooks:Add("MenuManagerInitialize", __Name(2), function(menu_manager)
	MenuCallbackHandler.callback_BulletDecapitations_Mneu_BodyBleedTime = function(self, item)
		BulletDecapitations._data.BodyBleedTime = math.round(tonumber(item:value()))
		pcall(function()
			io.save_as_json(BulletDecapitations._data, ThisModPath.."options_savefile.txt")
		end)
	end
	pcall(function()
		if io.file_is_readable(ThisModPath.."options_savefile.txt") then
			BulletDecapitations._data = io.load_as_json(ThisModPath.."options_savefile.txt")
		end
		MenuHelper:LoadFromJsonFile(ThisModPath.."settings.menu.json", BulletDecapitations, BulletDecapitations._data)
	end)
end)