local orig_NetworkPeer_send = NetworkPeer.send

function NetworkPeer:send(func_name, data, ...)
	if tostring(func_name) == "sync_outfit" then
		if data and type(data) == 'string' then
			local _res = managers.blackmarket:unpack_outfit_from_string(data) or {}
			if _res and ((_res.primary and _res.primary.cosmetics) or (_res.secondary and _res.secondary.cosmetics)) then
				if data:find('_skins2all_') then
					local datas = string.split(data, '_skins2all_')
					data = datas[1]
				end
			end
		end
	end
    orig_NetworkPeer_send(self, func_name, data, ...)
end