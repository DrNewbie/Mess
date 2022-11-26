local __file = file
local __io = io
local __os = os

local function __CheckFolder(is_online)
	local __identify_this_file = "disable.this.mod.when.online"
	local __r_ext = Idstring(__identify_this_file):key()
	local __check_this_directory = {
		[[assets/mod_overrides/]],
		[[mods/]]
	}
	for _, __dir in pairs(__check_this_directory) do
		if __file.DirectoryExists(__dir) then
			local __sub_dirs = __file.GetDirectories(__dir)
			if type(__sub_dirs) == "table" then
				for _, __dir_s in pairs(__sub_dirs) do
					if type(__dir_s) == "string" and __file.DirectoryExists(__dir..__dir_s.."/") then
						if __io.file_is_readable(__dir..__dir_s.."/"..__identify_this_file) then
							local this_dir = __dir..__dir_s.."/"
							if not is_online then
								__os.rename(this_dir.."mod."..__r_ext,		this_dir.."mod.txt")
								__os.rename(this_dir.."main."..__r_ext,		this_dir.."main.xml")
								__os.rename(this_dir.."supermod."..__r_ext,	this_dir.."supermod.xml")
								__os.rename(this_dir.."hooks."..__r_ext,	this_dir.."hooks.xml")
							else
								__os.rename(this_dir.."mod.txt",		this_dir.."mod."..__r_ext)
								__os.rename(this_dir.."main.xml",		this_dir.."main."..__r_ext)
								__os.rename(this_dir.."supermod.xml",	this_dir.."supermod."..__r_ext)
								__os.rename(this_dir.."hooks.xml",	this_dir.."hooks."..__r_ext)
							end
						end
					end
				end
			end
		end
	end
	return
end

--Main Menu: Enable
if MenuManager then
	Hooks:Add("MenuManagerOnOpenMenu", "DisableModsWhenOnline0", function(self, menu, ...)
		if menu == "menu_main" then
			pcall(__CheckFolder, false)
		end
	end)
end

--Crime.Net: Disable when Offline
if CrimeNetGui then
	Hooks:PostHook(CrimeNetGui, "init", "DisableModsWhenOnline1", function(self, ...)
		if Global.game_settings and Global.game_settings.single_player then
			pcall(__CheckFolder, false)
		else
			pcall(__CheckFolder, true)
		end
	end)
end

--Lobby: Disable
if MenuSceneManager then
	Hooks:PostHook(MenuSceneManager, "set_lobby_character_out_fit", "DisableModsWhenOnline2", function(self, ...)
		pcall(__CheckFolder, true)
	end)
end

--MatchMaking: Disable
if NetworkMatchMakingSTEAM then
	Hooks:PreHook(NetworkMatchMakingSTEAM, "join_server_with_check", "DisableModsWhenOnline3", function(self, ...)
		pcall(__CheckFolder, true)
	end)
end