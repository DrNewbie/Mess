local ThisModPath = ModPath

local __Name = function(__id)
	return "Lobby_"..Idstring(tostring(__id).."::"..ThisModPath):key()
end

Hooks:PostHook(CrimeNetGui, "add_server_job", __Name("add_server_job"), function(self, __data, ...)
	if type(__data) == "table" and __data.id and __data.room_id then
		local __icon_texture = nil
		if type(EpicMM) == "userdata" and type(EpicMM.lobby) == "function" then
			local lobby = EpicMM:lobby(__data.room_id)
			if type(lobby) == "userdata" and type(lobby.key_value) == "function" then
				local owner_account_id = tostring(lobby:key_value("owner_account_id"))
				if string.len(owner_account_id) > 17 then
					--Epic
					__icon_texture = "guis/dlcs/shub/textures/epic_player_icon"
				elseif string.len(owner_account_id) == 17 then
					--Steam
					__icon_texture = "guis/dlcs/shub/textures/steam_player_icon"
				end
			end
		end
		local job = self._jobs[__data.id]
		if __icon_texture and type(job) == "table" and type(job.icon_panel) == "userdata" and type(job.side_panel.child) == "function" then
			local host_name = job.side_panel:child("host_name")
			local job_name = job.side_panel:child("job_name")
			local __x = 0
			if host_name:right() >= job_name:right() then
				__x = host_name:right()
			else
				__x = job_name:right()
			end
			local MM_icon = job.side_panel:bitmap({
				name = "host_MM_icon",
				h = 32,
				w = 32,
				alpha = 1,
				blend_mode = "normal",
				y = host_name:y() - 4,
				x = __x + 2,
				layer = 0,
				texture = __icon_texture,
				color = Color.white,
				visible = true
			})
		end
	end
end)