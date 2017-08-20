	function MenuManager:select_message_from_list(params)
		local _select_list = {}
		
		local file, err = io.open("mods/Other Chat Menu/Chat_List.txt", "r")
		
		if not file then
			return
		end	
		local line = file:read()
		local _txt = tostring(line)
		local count = 0
		while line do
			table.insert(_select_list, _txt)
			line = file:read()
			_txt = tostring(line)
		end	
		file:close()
		
		if not _select_list then return end
		local opts = {}
		local start = params.start or 0
		start = start >= 0 and start or 0
		for k, _msg in pairs(_select_list) do
			if k > start then
				opts[#opts+1] = { text = "" .. _msg, callback_func = callback(self, self, "select_message_from_list_done", {msg = _msg}) }
			end
			if (#opts) >= 17 then
				start = k
				break
			end
		end
		opts[#opts+1] = { text = "[Next]----------------------------", callback_func = callback(self, self, "select_message_from_list", {start = start}) }
		opts[#opts+1] = { text = "[Back to Main]---------------", callback_func = callback(self, self, "select_message_from_list", {}) }
		opts[#opts+1] = { text = "[Cancel]", is_cancel_button = true }
		local _dialog_data = {
			title = "CHAT MENU",
			text = "",
			button_list = opts,
			id = tostring(math.random(0,0xFFFFFFFF))
		}
		if managers.system_menu then
			managers.system_menu:show(_dialog_data)
		end
	end
	
	function MenuManager:select_message_from_list_done(params)
		if params and params.msg then
			managers.chat:send_message(ChatManager.GAME, "", params.msg or "")
		end
	end

	managers.menu:select_message_from_list({start = 0})