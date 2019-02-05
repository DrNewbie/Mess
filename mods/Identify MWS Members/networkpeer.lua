local function Peer_Is_MWS_Meber_Announce(user_name, is_bool)
	if is_bool then
		managers.chat:_receive_message(1, "[MWS YES]", user_name.." is Mod Workshop member!", Color("00c8c8"))
	else
		managers.chat:_receive_message(1, "[MWS NO]", user_name.." isn't Mod Workshop member!", Color("c8c800"))
	end
end

function NetworkPeer:Is_MWS_Member()
	if not self._user_id or not self._name then
		return
	end
	local user_id = tostring(self._user_id)
	local user_name = tostring(self._name)
	if Steam:is_user_in_source(user_id, "103582791456186251") then
		Peer_Is_MWS_Meber_Announce(user_name, true)
	else
		local uurl = "https://www.google.com/search?q="..user_id.."+site:modworkshop.net/member.php?action=profile"
		dohttpreq(uurl,
			function (search_page)
				search = tostring(search_page)
				local mwsuid = tonumber(tostring(string.match(search_page, 'https://www.modworkshop.net/member.php?action=profile&uid=(%d+)')))
				if mwsuid and mwsuid > 0 then
					local mwsurl = "www.modworkshop.net/member.php?action=profile&="..mwsuid
					dohttpreq(mwsuid,
						function (mws_upage)
							mws_upage = tostring(search_page)
							if mws_upage:find(user_id) then
								Peer_Is_MWS_Meber_Announce(user_name, true)
							else
								Peer_Is_MWS_Meber_Announce(user_name, false)
							end
						end
					)
				else
					Peer_Is_MWS_Meber_Announce(user_name, false)
				end
			end
		)
	end
end

Hooks:PostHook(NetworkPeer, "set_is_vr", "DoPeerCheckForMWSInfoRun1", function(self)
	local peer = self
	DelayedCalls:Add("F_"..Idstring("DelayedModMWSInfo1"..tostring(peer)):key(), 10, function()
		peer:Is_MWS_Member()
	end)
end)

Hooks:Add("NetworkManagerOnPeerAdded", "DoPeerCheckForMWSInfoRun2", function(peer, peer_id)
	DelayedCalls:Add("DelayedModMWSInfo2"..tostring(peer_id), 10, function()
		peer:Is_MWS_Member()
	end)
end)

Hooks:PostHook(NetworkPeer, "set_loading", "DoPeerCheckForMWSInfoRun3", function(self, state)
	local peer = self
	if self._loaded == true then
		DelayedCalls:Add("F_"..Idstring("DelayedModMWSInfo3"..tostring(peer)):key(), 10, function()
			peer:Is_MWS_Member()
		end)
	end
end)

Hooks:Add("BaseNetworkSessionOnLoadComplete", "NoobJoin:DoPeerCheckForMWSInfoRun4", function(peer, id)
	DelayedCalls:Add("F_"..Idstring("DelayedModMWSInfo4"..tostring(peer)):key(), 10, function()
		peer:Is_MWS_Member()
	end)
end)