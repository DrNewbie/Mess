local mod_ids = ModPath and Idstring(ModPath):key() or tostring(math.random())
local hook1 = "MOD0_"..Idstring("hook1::"..mod_ids):key()

local function __Is_Kiced(__hours)
	if type(__hours) == "number" and __hours > 1000 then
		return true
	end
	return false
end

local function __App_ID()
	return 218620
end

local function __CheckPeer(peer_id)
	if not managers.network or not managers.network:session() then
		log("[NGBTUwU]: \t not managers.network")
		return
	end
	local peer_now = managers.network:session():peer(peer_id)
	if not peer_now then
		log("[NGBTUwU]: \t no peer_now")
		return
	end
	if peer_now == managers.network:session():local_peer() then
		log("[NGBTUwU]: \t peer_now == local_peer")
		return
	end
	local steamid64 = tostring(peer_now:user_id())
	local user_name = tostring(peer_now:name())
	dohttpreq("http://steamcommunity.com/profiles/".. steamid64 .. "/games?l=english&tab=all&xml=1",
		function(page)
			local _hoursOnRecord
			local is_break_all
			local s_app_id = __App_ID()
			page = tostring(page)
			if page:find('<appID>'..s_app_id..'</appID>') then
				page = page:gsub('<appID>', '<appID><![CDATA[')
				page = page:gsub('</appID>', ']]></appID>')
				page = page:gsub('<hoursOnRecord>', '<hoursOnRecord><![CDATA[')
				page = page:gsub('</hoursOnRecord>', ']]></hoursOnRecord>')
				local xml = Node.from_xml(page)
				if xml and xml:children() then
					for xml_child_node in xml:children() do
						if is_break_all then break end
						if xml_child_node:name() == "games" and xml_child_node:children() then
							for xml_child_node_i in xml_child_node:children() do
								if is_break_all then break end
								if xml_child_node_i:children() then
									if xml_child_node_i:name() == "game" then
										local get_c_xml = tostring(xml_child_node_i:to_xml())
										if get_c_xml:find('<appID><!%[CDATA%['..s_app_id..'%]%]></appID>') then
											_hoursOnRecord = tostring(string.match(get_c_xml, '<hoursOnRecord><!%[CDATA%[(.*)%]%]></hoursOnRecord>'))
											_hoursOnRecord = _hoursOnRecord:gsub(',', '')
											_hoursOnRecord = tonumber(_hoursOnRecord) or nil
											is_break_all = true
											break
										end
									end
								end
							end
						end
					end
				end
			end
			if _hoursOnRecord then
				managers.chat:_receive_message(1, "[NGBTUwU]", "'"..user_name.."' has played ".._hoursOnRecord.." hours.", Color.green)
			else
				managers.chat:_receive_message(1, "[NGBTUwU]", "'"..user_name.."' has hidden profiles.", Color.green)
			end
			if Network:is_server() and __Is_Kiced(_hoursOnRecord) then
				managers.network:session():send_to_peers("kick_peer", peer_id, 2)
				managers.network:session():on_peer_kicked(peer_now, peer_id, 2)
			end
		end
	)
end

if NetworkPeer then
	Hooks:PostHook(NetworkPeer, "set_ip_verified", hook1, function(self)
		if Network and Network:is_server() and self and self.id then
			__CheckPeer(self:id())
		end
	end)
end