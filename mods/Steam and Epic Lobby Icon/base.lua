local ThisModPath = ModPath

local __Name = function(__id)
	return "Lobby_"..Idstring(tostring(__id).."::"..ThisModPath):key()
end

local EGS_ICON_PATH = __Name("egs_ico")

local STEAM_ICON_PATH = __Name("steam_ico")

local ICON_SIZE = 16

pcall(function()
	BLTAssetManager:CreateEntry( 
		Idstring(EGS_ICON_PATH), 
		Idstring("texture"), 
		ThisModPath.."/platformIcons/egs_ico_16px.dds", 
		nil 
	)
	BLTAssetManager:CreateEntry( 
		Idstring(STEAM_ICON_PATH), 
		Idstring("texture"), 
		ThisModPath.."/platformIcons/steam_ico_16px.dds", 
		nil 
	)
end)

Hooks:PostHook(CrimeNetGui, "add_server_job", __Name("add_server_job"), function(self, __data, ...)
	if type(__data) == "table" and __data.id and __data.room_id then
		local __icon_texture = nil
		if type(EpicMM) == "userdata" and type(EpicMM.lobby) == "function" then
			local lobby = EpicMM:lobby(__data.room_id)
			if type(lobby) == "userdata" and type(lobby.key_value) == "function" then
				local owner_account_id = tostring(lobby:key_value("owner_account_id"))
				if string.len(owner_account_id) > 17 then
					--Epic
					__icon_texture = EGS_ICON_PATH
				elseif string.len(owner_account_id) == 17 then
					--Steam
					__icon_texture = STEAM_ICON_PATH
				end
			end
		end
		local job = self._jobs[__data.id]
		if __icon_texture and type(job) == "table" and type(job.icon_panel) == "userdata" and type(job.side_panel.child) == "function" then
			local host_name = job.side_panel:child("host_name")
			local MM_icon = job.side_panel:bitmap({
				name = "host_MM_icon",
				h = ICON_SIZE,
				w = ICON_SIZE,
				alpha = 1,
				blend_mode = "normal",
				y = 2,
				x = host_name:left() + 1,
				layer = 0,
				texture = __icon_texture,
				color = Color.white,
				visible = true
			})
			host_name:set_center_x(host_name:center_x() + ICON_SIZE + 3)
		end
	end
end)