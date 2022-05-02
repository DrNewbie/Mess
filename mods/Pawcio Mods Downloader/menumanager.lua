local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local __Name = function(__id)
	return "PMD_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end

local function __GetModList()
	local __file = io.open(ThisModPath.."mod_list.json", "r")
	if __file then
		local __is_chanage = false
		local __mod_list = __file:read("*a")
		__file:close()
		__mod_list = json.decode(__mod_list)
		if type(__mod_list) == "table" and not table.empty(__mod_list) then
			for __id, __bool in pairs(__mod_list) do
				if type(__bool) == "boolean" and not __bool then
					if not __is_chanage then
						__is_chanage = true
						QuickMenu:new("Pawcio Mods Downloader", "loading...", {}):Show()
					end
					__mod_list[__id] = true
					__id = string.gsub(tostring(__id), "id_", "")
					local __ids = __Name(__id)
					local __tmp_path = "mods/____"..__ids.."/"
					os.execute('mkdir "'.. Application:nice_path(Application:base_path().."/"..__tmp_path, true) ..'"')
					local __ff = io.open(__tmp_path.."/main.xml", "w+")
					if __ff then
						__ff:write('<table name="'..__ids..'"> <AssetUpdates id="'..__id..'" version="0" provider="modworkshop"/> </table>')
						__ff:close()
					end
				end
			end
		end
		if __is_chanage then
			__file = io.open(ThisModPath.."mod_list.json", "w+")
			if __file then
				__file:write(json.encode(__mod_list))
				__file:close()
			end
			DelayedCalls:Add(__Name("DelayedCalls::ReLoad"), 3, function()
				if setup and setup.load_start_menu then
					setup:load_start_menu()
				end
			end)
		end
	end
end

Hooks:Add("MenuManagerOnOpenMenu", __Name("MenuManagerOnOpenMenu"), function(self, menu)
	if ModCore and (menu == "menu_main" or menu == "lobby")  then
		DelayedCalls:Add(__Name("DelayedCalls::1s"), 1, function()
			__GetModList()
		end)
	end
end)