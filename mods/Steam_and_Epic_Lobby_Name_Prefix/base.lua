local ThisModPath = ModPath

local __Name = function(__id)
	return "Lobby_"..Idstring(tostring(__id).."::"..ThisModPath):key()
end

local __EpicPrefix = function(__name)
	return "[E] "..__name
end

local __SteamPrefix = function(__name)
	return "[S] "..__name
end

local Hook1 = __Name("add_server_job")

CrimeNetGui[Hook1] = CrimeNetGui[Hook1] or CrimeNetGui.add_server_job

function CrimeNetGui:add_server_job(data, ...)
	if type(EpicMM) == "userdata" and type(EpicMM.lobby) == "function" then
		local lobby = EpicMM:lobby(data.room_id)
		if type(lobby) == "userdata" and type(lobby.key_value) == "function" then
			local owner_account_id = tostring(lobby:key_value("owner_account_id"))
			if string.len(owner_account_id) > 17 then
				--Epic
				data.host_name = __EpicPrefix(data.host_name)
			elseif string.len(owner_account_id) == 17 then
				--Steam
				data.host_name = __SteamPrefix(data.host_name)		
			end
		end
	end
	self[Hook1](self, data, ...)
end