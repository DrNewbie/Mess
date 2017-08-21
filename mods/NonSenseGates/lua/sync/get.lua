if not Network:is_client() then
	return
end

_G.NoSenseGate = _G.NoSenseGate or {}

if not NoSenseGate then
	return
end

Hooks:Add("NetworkReceivedData", "NetworkReceivedData_NoSenseGate_Client", function(sender, sync_asked, data)
	if sync_asked and data then
		if sync_asked == "Sync_Spawn" then
			local _hash_name_list = {
				["1be68929e3c6b16d"] = "units/payday2/architecture/bnk/bnk_int_fence_gate",
				["8db557d0f2995322"] = "units/payday2/architecture/bnk/bnk_int_fence_wall_short"
			}
			local _var1 = mysplit(tostring(data), ";")
			if _hash_name_list[_var1[1]] then
				local _var2 = mysplit(_var1[2], ",")
				local _var3 = mysplit(_var1[3], ",")
				safe_spawn_unit(Idstring(_hash_name_list[_var1[1]]), Vector3(tonumber(_var2[1]), tonumber(_var2[2]), tonumber(_var2[3])), Rotation(tonumber(_var3[1]), tonumber(_var3[2]), tonumber(_var3[3])))
			end
		end
	end
end)

function mysplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end