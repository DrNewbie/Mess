local function EN2LEETChat(message)
	local Convert_List = {
		a = {"a", "4", "@", "4", "@"},
		b = {"b", "8", "6", "l3", "8", "6", "l3"},
		c = {"c", "<", "(", "<", "("},
		d = {"d", "|)", "|)"},
		e = {"e", "3", "3"},
		f = {"f"},
		g = {"g", "9", "gee", "9", "gee"},
		h = {"h", "#", "#"},
		i = {"i", "|", "1", "|", "1"},
		j = {"j"},
		k = {"k"},
		l = {"l", "1", "|_", "1", "|_"},
		m = {"m", "m", "(V)", "|V|"},
		n = {"n", "n", "(\\)"},
		o = {"o", "0", "()", "0", "()"},
		p = {"p", "p", "|D"},
		q = {"q", "q", "(,)"},
		r = {"r"},
		s = {"s", "$", "$"},
		t = {"t", "7", "+", "7", "+"},
		u = {"u", "u", "(_)"},
		v = {"v", "v", "\\/"},
		w = {"w", "w", "'//"},
		x = {"x", "x", "%"},
		y = {"y"},
		z = {"z", "2", "2"}
	}
	for en, leet in pairs(Convert_List) do
		message = message:gsub(en, leet[math.random(#leet)])
	end
	for en, leet in pairs(Convert_List) do
		message = message:gsub(string.upper(en), leet[math.random(#leet)])
	end
	local message_len = string.len(message)
	local message_buff = (message_len + 9) / 3
	local i = 0
	local z = 1
	if message_buff < message_len then
		while i < message_len and z < 20 do
			z = z + 1
			local r = math.round(math.random() * message_buff)
			if i + r > message_len then
				r = message_len - i
			end
			if r > 0 then
				local s_s = string.sub(message, 1, i - 1)
				local pick = string.sub(message, i, i + r)
				local e_s = string.sub(message, i + r + 1, message_len)
				if r%2 == 1 then
					pick = string.upper(pick)
				else
					pick = string.lower(pick)
				end
				message = s_s .. pick .. e_s
				i = i + r
			end
		end
	end
	return message
end

local EN2LEET_send_message = ChatManager.send_message
function ChatManager:send_message(channel_id, sender, message, ...)
	math.randomseed(tostring(os.time()):reverse():sub(1, 6))
	EN2LEET_send_message(self, channel_id, sender, EN2LEETChat(message), ...)
end
