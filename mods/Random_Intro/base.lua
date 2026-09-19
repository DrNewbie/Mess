local ThisModPath = tostring(ModPath)
local __NameIds = function(__data)
	return "RI_"..Idstring(ThisModPath..string.format("%q", __data)):key()
end
local Hook1 = __NameIds("Hook1")
local Hook2 = __NameIds("Hook2")
local Function1 = __NameIds("Function1")
local ThoseMovies = {}
_G[Function1] = function(__this_dir)
	if not file.DirectoryExists(__this_dir) then
		return {}
	end
	local __i, __t, __st, __pfile, __pdir = 0, {}, {}, file.GetFiles(__this_dir), file.GetDirectories(__this_dir)
	for _, __filename in pairs(__pfile) do
		__filename = string.lower(tostring(__filename))
		if (string.match(__filename, "%.movie") or string.match(__filename, "%.bik")) and io.file_is_readable(__this_dir.."/"..__filename) then
			__i = __i + 1
			__t[__NameIds(__this_dir..__filename)] = __this_dir.."/"..__filename
			ThoseMovies[__NameIds(__this_dir.."/"..__filename)] = __this_dir.."/"..__filename
		end
	end
	if type(__pdir) == "table" then
		for _, __foldername in pairs(__pdir) do
			__st = _G[Function1](__this_dir.."/"..__foldername.."/")
		end
	end
	return __t
end

Hooks:Add("MenuManagerOnOpenMenu", Hook1, function(self, menu)
	if menu == "menu_main" then
		DelayedCalls:Add(Hook2, 1, function()
			_G[Function1](ThisModPath.."/resources/")
			if type(ThoseMovies) == "table" and not table.empty(ThoseMovies) then
				local ThisMoveieFrom = ThoseMovies[table.random_key(ThoseMovies)]
				if type(ThisMoveieFrom) == "string" and io.file_is_readable(ThisMoveieFrom) then
					local ThisMoveieFileFrom = io.open(ThisMoveieFrom, "rb")
					if ThisMoveieFileFrom then
						local ThisMoveieFileFromData = ThisMoveieFileFrom:read("*all")
						local ThisMoveieTo = ThisModPath.."/assets/movies/intro_trailer.movie"
						if io.file_is_readable(ThisMoveieTo) then
							os.remove(ThisMoveieTo)
						end
						local ThisMoveieFileTo = io.open(ThisMoveieTo, "wb+")
						if ThisMoveieFileTo then
							ThisMoveieFileTo:write(ThisMoveieFileFromData)
							ThisMoveieFileTo:close()
						end
						ThisMoveieFileFrom:close()
					end
				end
			end
		end)
	end
end)