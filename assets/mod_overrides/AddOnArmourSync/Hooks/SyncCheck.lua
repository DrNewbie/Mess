FakeSyncFixList = FakeSyncFixList or {}

FakeSyncInitList = FakeSyncInitList or {}

function AddOnArmourSyncFix_OutfitString(peer, d1, d2, d3, d4, ...)
	if peer and peer.id and peer:id() and d1 then
		local _d1t = tostring(d1)
		if _d1t == 'sync_outfit' or string.ends(_d1t, "set_unit") then
			local str = string.ends(_d1t, "set_unit") and d4 or d2
			local bm = managers.blackmarket
			if is_henchman and not bm.unpack_henchman_loadout_string then
				is_henchman = false
			end
			local list = (is_henchman and bm.unpack_henchman_loadout_string) and bm:unpack_henchman_loadout_string(str) or bm:unpack_outfit_from_string(str)
			local bta = tweak_data.blackmarket.armors
			if bta then
				local id = peer:id()
				local armor
				FakeSyncFixList[id] = FakeSyncFixList[id] or {}
				if list.armor_current_state and (not FakeSyncFixList[id] or not FakeSyncFixList[id][list.armor_current_state]) and bta[list.armor_current_state].custom then
					armor = list.armor_current_state
					list.armor_current_state = bta[list.armor_current_state].base_on
				end
				if list.armor and (not FakeSyncFixList[id] or not FakeSyncFixList[id][list.armor]) and bta[list.armor].custom then
					armor = list.armor
					list.armor = bta[list.armor].base_on
				end
				if list.armor_current and (not FakeSyncFixList[id] or not FakeSyncFixList[id][list.armor_current]) and bta[list.armor_current].custom then
					armor = list.armor_current
					list.armor_current = bta[list.armor_current].base_on
				end
				if armor then
					local _Net = _G and _G.LuaNetworking or nil
					if not FakeSyncInitList[id] or tostring(FakeSyncInitList[id]) ~= peer:user_id() then
						FakeSyncInitList[id] = peer:user_id()
						FakeSyncFixList[id] = {}
						_Net:SendToPeer(id, "AddOnArmourAsk", armor)
					end
				end
				str = BeardLib.Utils:OutfitStringFromList(list, is_henchman)
				if string.ends(_d1t, "set_unit") then
					d4 = str
				else
					d2 = str
				end
			end
		end
	end
	return d1, d2, d3, d4, ...
end

local AddOnArmourSyncFix_send_after_load = NetworkPeer.send_after_load

function NetworkPeer:send_after_load(...)
	AddOnArmourSyncFix_send_after_load(self, AddOnArmourSyncFix_OutfitString(self, ...))
end

local AddOnArmourSyncFix_send_queued_sync = NetworkPeer.send_queued_sync

function NetworkPeer:send_queued_sync(...)
	AddOnArmourSyncFix_send_queued_sync(self, AddOnArmourSyncFix_OutfitString(self, ...))
end


Hooks:Add("NetworkReceivedData", "NetReceived_AddOnArmourSyncFix", function(sender, sync_asked, data)
	local _Net = _G and _G.LuaNetworking or nil
	if sync_asked and data and _Net then
		local _AddOnArmourHash = function(id)
			if not tweak_data.blackmarket.armors then
				return 0
			end
			return Idstring(
						tostring(
							json.encode(
								{
									bm = tweak_data.blackmarket.armors[id] or 0
								}
							)
						)
					):key()
		end
		if sync_asked == "AddOnArmourAsk" then
			data = tostring(data)
			sender = tonumber(sender)
			if sender >= 1 then
				_Net:SendToPeer(sender, "AddOnArmourReply", data..',,,'.._AddOnArmourHash(data))
			end
		elseif sync_asked == "AddOnArmourReply" then
			data = string.split(tostring(data), ",,,")
			data[1] = tostring(data[1])
			data[2] = tostring(data[2])
			sender = tonumber(sender)
			if sender >= 1 then
				if tweak_data.blackmarket.armors[data[1]] and _AddOnArmourHash(data[1]) == data[2] then
					log('[AddOnArmour]: OK!! '..sender..' , '..data[1]..' , '..data[2])
					FakeSyncFixList[sender][data[1]] = true
				else
					log('[AddOnArmour]: False!! '..sender..' , '..data[1]..' , '..data[2])
				end
			end
		end
	end
end)

_G.AddOnArmourSyncFix_Init = true