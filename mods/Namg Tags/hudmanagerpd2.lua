local ThisModPath = ModPath

Hooks:PostHook(HUDManager, "add_teammate_panel", "OhhhhhhhLoadNameTagConfig", function(self)
	if not self.NameTagConfig then
		self.NameTagRGB = {}
		local xfile = io.open(ThisModPath.."Config.json", "r")
		if xfile then
			self.NameTagConfig = json.decode(xfile:read("*all"))
			xfile:close()
		end
	end
end)

Hooks:PostHook(HUDManager, "set_teammate_name", "OhhhhhhhGiveNameTagNow", function(self, peer_id)
	if type(self.NameTagConfig) == "table" then
		local peer = managers.network:session():peer(peer_id)
		if not peer then
			return
		end
		local name_label = self:_name_label_by_peer_id(peer_id)
		if name_label then
			local sData
			if type(self.NameTagConfig.SteamID) == "table" and self.NameTagConfig.SteamID[tostring(peer:user_id())] then
				sData = self.NameTagConfig.SteamID[tostring(peer:user_id())]
			elseif type(self.NameTagConfig.Random) == "table" then
				sData = self.NameTagConfig.Random[table.random_key(self.NameTagConfig.Random)]
			end
			if type(sData) == "table" and sData.text then
				name_label.panel:child("cheater"):set_text(tostring(sData.text))
				name_label.panel:child("cheater"):set_visible(true)
				if sData.color then
					self.NameTagRGB[peer_id] = nil
					sData.color = tostring(sData.color)
					if sData.color == "Default" and name_label.panel:child("text") and name_label.panel:child("text").color then
						name_label.panel:child("cheater"):set_color(name_label.panel:child("text"):color())
					elseif sData.color == "RGB" then
						self.NameTagRGB[peer_id] = true						
					elseif sData.color == "Random" then
						local now = TimerManager:game():time()
						local red = math.sin(135 * now) / 2 + 0.5
						local green = math.sin(140 * now + 60) / 2 + 0.5
						local blue = math.sin(145 * now + 120) / 2 + 0.5
						name_label.panel:child("cheater"):set_color(Color(red, green, blue, 0))
					else
						name_label.panel:child("cheater"):set_color(Color(sData.color))
					end
				end
			end
		end
	end
end)

Hooks:PostHook(HUDManager, "update", "OhhhhhhhNameTagLoop", function(self, t, dt)
	if type(self.NameTagConfig) == "table" then
		if type(self.NameTagRGB) == "table" then
			for peer_id, d in pairs(self.NameTagRGB) do
				local name_label = self:_name_label_by_peer_id(peer_id)
				if d and name_label and name_label.panel then
					local red = math.sin(135 * t) / 2 + 0.5
					local green = math.sin(140 * t + 60) / 2 + 0.5
					local blue = math.sin(145 * t + 120) / 2 + 0.5
					name_label.panel:child("cheater"):set_color(Color(red, green, blue, 0))
				end
			end
		end
	end
end)