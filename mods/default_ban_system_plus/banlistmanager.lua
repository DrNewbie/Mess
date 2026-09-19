local __ModPath = ModPath

function BanListManager:__save_banned_list()
	local __tmp = {}
	local __time = tostring(os.date("!%H:%M:%S"))
	local __data = self:ban_list()
	__data.__date = __time.." , "..Idstring(tostring(os.time()).." "..__time):key()
	local __file = io.open(__ModPath.."__banned_list.txt", "w+")
	if __file then
		__file:write( json.encode( __data ) )
		__file:close()
		self:__read_banned_list()
	end
end

function BanListManager:__read_banned_list()
	local __file = io.open(__ModPath.."__banned_list.txt", "r")
	local __tmp = {}
	if not __file then
		self:__save_banned_list()
	else
		local __text = __file:read("*all")		
		local function urlEncode(s)
			return string.sub(string.gsub(s, "([^%w%.%- ])", function(c) return string.format("%%%02X", string.byte(c)) end), 1, 32)
		end
		for _, __ban in pairs(self:ban_list()) do
			if type(__ban) == "table" and not __text:find('"identifier":"'..tostring(__ban.identifier)..'"') then
				self:unban(__ban.identifier)
			end
		end
		for __w in string.gmatch(__text, '"identifier":"(%d+)"') do
			local __key = "K_"..Idstring(tostring(__w)):key()
			if not __tmp[__key] then
				__tmp[__key] = true
				dohttpreq("http://steamcommunity.com/profiles/".. __w .. "/games?l=english&xml=1",
					function(page)
						if not self:banned(__w) and page:find('<steamID><!%[CDATA%[(.*)%]%]></steamID>') then
							local player_steam_name = tostring(string.match(page, '<steamID><!%[CDATA%[(.*)%]%]></steamID>'))
							self:ban(urlEncode(__w), urlEncode(player_steam_name))
						end
					end
				)
			end
		end
		local __tmp2 = {}
		for __id, __ban in pairs(self:ban_list()) do
			if type(__ban) == "table" and __ban.identifier then
				local __key = "K_"..Idstring(tostring(__ban.identifier)):key()
				if not __tmp2[__key] then
					__tmp2[__key] = true
				else
					table.remove(self._global.banned, __id)
				end
			end
		end
	end
end

Hooks:PostHook(BanListManager, 'load', "F_"..Idstring("BanListManager:load:default ban system plus"):key(), function(self)
	self:__read_banned_list()
end)

Hooks:PostHook(BanListManager, 'save', "F_"..Idstring("BanListManager:save:default ban system plus"):key(), function(self)
	self:__save_banned_list()
end)

Hooks:PostHook(BanListManager, 'init', "F_"..Idstring("BanListManager:init:default ban system plus"):key(), function(self)
	self:__read_banned_list()
end)

Hooks:PreHook(MenuCallbackHandler, 'unban_player', "F_"..Idstring("MenuCallbackHandler:unban_player:default ban system plus"):key(), function(self, item, force)
	if not force and item:parameters().identifier and item:parameters().name then
		local dialog_data = {
			title = managers.localization:text("dialog_sure_to_unban_title"),
			text = managers.localization:text("dialog_sure_to_unban_body", {
				USER = item:parameters().name
			})
		}
		local yes_button = {
			text = managers.localization:text("dialog_yes"),
			callback_func = callback(self, self, "unban_player", item, force)
		}
		local no_button = {
			text = managers.localization:text("dialog_no"),
			cancel_button = true
		}
		local who_button = {
			text = "Who this guy?",
			callback_func = function ()
				Steam:overlay_activate("url", "https://steamrep.com/profiles/"..tostring(item:parameters().identifier))
			end
		}
		dialog_data.button_list = {
			who_button,
			yes_button,
			no_button
		}
		managers.system_menu:show(dialog_data)
		return
	end
end)