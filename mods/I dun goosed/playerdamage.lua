Hooks:PostHook(PlayerDamage, "_on_enter_swansong_event", "F_"..Idstring("PostHook:PlayerDamage:_on_enter_swansong_event:I dun goosed"):key(), function(self)
	if self.swansong then
		managers.chat:send_message(ChatManager.GAME, "", 'I dun goosed')
	end
end)