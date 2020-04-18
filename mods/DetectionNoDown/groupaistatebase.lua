Hooks:PostHook(GroupAIStateBase, "init", "F_"..Idstring("PostHook:GroupAIStateBase:init:Detection No Down"):key(), function(self)
	if (Network and Network:is_server()) or Global.game_settings.single_player then
		self.__suspicion_peek_dt = 0
		self.__suspicion_peek_last = nil
		self.__add_suspicion_amount = 0
		self.__hold_suspicion_amount = 0
	end
end)

function GroupAIStateBase:__set_add_suspicion_amount(__var)
	self.__add_suspicion_amount = __var
end

function GroupAIStateBase:__get_add_suspicion_amount()
	return self.__add_suspicion_amount
end

function GroupAIStateBase:__set_hold_suspicion_amount(__var)
	self.__hold_suspicion_amount = __var
end

function GroupAIStateBase:__get_hold_suspicion_amount()
	return self.__hold_suspicion_amount
end

Hooks:PostHook(GroupAIStateBase, "on_criminal_suspicion_progress", "F_"..Idstring("PostHook:GroupAIStateBase:on_criminal_suspicion_progress:Detection No Down"):key(), function(self, u_suspect, u_observer, status)
	if (Network and Network:is_server()) or Global.game_settings.single_player then
		local local_player = managers.player:local_player()
		local __now = TimerManager:game():time()
		local __is_suspicion = false
		if type(u_suspect) == "userdata" and type(u_observer) == "userdata" and type(status) == "number" then
			__is_suspicion = true
		end
		if __now - self.__suspicion_peek_dt > 0.5 then
			if __is_suspicion then
				if u_observer:base().is_security_camera then
					self.__add_suspicion_amount = self.__add_suspicion_amount + 0.1
				else
					self.__add_suspicion_amount = self.__add_suspicion_amount + 0.25
				end
			end
		end
		if __is_suspicion and (not self.__suspicion_peek_last or self.__suspicion_peek_last ~= u_observer) then
			self.__suspicion_peek_last = u_observer
			self.__suspicion_peek_dt = -1
		else
			self.__suspicion_peek_dt = __now
		end
	end
end)