_G.NGBTOwO = _G.NGBTOwO or {}

function NGBTOwO:App_ID()
	return 218620
end


function NGBTOwO:Check(peer_id)
	if not managers.network or not managers.network:session() then
		log("[NGBTOwO]: \t not managers.network")
		return
	end
	local peer_now = managers.network:session():peer(peer_id)
	if not peer_now then
		log("[NGBTOwO]: \t no peer_now")
		return
	end
	if peer_now == managers.network:session():local_peer() then
		log("[NGBTOwO]: \t peer_now == local_peer")
		return
	end
	local steamid64 = tostring(peer_now:user_id())
	local user_name = tostring(peer_now:name())
	dohttpreq("https://crowbar.steamstat.us/Barney",
		function(steam_check)
			steam_check = tostring(steam_check)
			local json_steam_check = json.decode(steam_check)
			if json_steam_check and json_steam_check.success and json_steam_check.services and json_steam_check.services and json_steam_check.services.community and tostring(json_steam_check.services.community.status) == "good" then
				log("[Steamstat]:\tIt's good.")
				dohttpreq("http://steamcommunity.com/profiles/".. steamid64 .. "/games?l=english&tab=all&xml=1",
					function(page)
						local _hoursOnRecord
						local is_break_all
						local s_app_id = NGBTOwO:App_ID()
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
														_hoursOnRecord = tonumber(_hoursOnRecord) or 0
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
							managers.chat:_receive_message(1, "[NGBTOwO]", "'"..user_name.."' has played ".._hoursOnRecord.." hours.", Color.green)
						else
							managers.chat:_receive_message(1, "[NGBTOwO]", "I can't read how many hours '"..user_name.."' has played.", Color.green)
						end
					end
				)
			else
				log("[Steamstat]:\tIt's bad.")
				managers.chat:_receive_message(1, "[NGBTOwO]", "Oops, Steam is dead", Color.green)
			end
		end
	)
end

function NGBTOwO:Check_All()
	local _dt = 0
	for peer_id, _ in pairs(managers.network:session():peers()) do
		_dt = _dt + 3
		DelayedCalls:Add('DelayedModNGBTOwOXXX_' .. tostring(peer_id), 1 + _dt, function()
			NGBTOwO:Check(peer_id)
		end)
	end
end
