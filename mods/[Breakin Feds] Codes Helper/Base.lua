if not Global.game_settings or not Global.game_settings.level_id or not Global.game_settings.level_id == "tag" then
	return
end

_G.CodesHelper = _G.CodesHelper or {}

CodesHelper._CodesAns = CodesHelper._CodesAns or {}

Hooks:PostHook(DialogManager, "queue_dialog", "CodesHelper_Announce", function(self, id, params)
	if Global.game_settings.level_id == "tag" and type(CodesHelper._CodesAns) == "table" and (CodesHelper._CodesAns.Stuff or CodesHelper._CodesAns.Keypad) then
		if id == "Play_loc_tag_82" then
			local AnsMsg = "[Helper]: "..tostring(json.encode(CodesHelper._CodesAns))
			managers.chat:send_message(ChatManager.GAME, "", AnsMsg)
			managers.hud:show_hint({text = AnsMsg})
		elseif id == "Play_loc_tag_44" or id == "Play_loc_tag_64" then
			CodesHelper._CodesAns = nil
		end
	end
	if id ~= "Play_loc_tag_83" then
		self:queue_dialog("Play_loc_tag_83", params)
	end
end)

function CodesHelper:Set_Codes(data)
	for i, d in pairs(data) do
		CodesHelper._CodesAns[i] = d
	end
end