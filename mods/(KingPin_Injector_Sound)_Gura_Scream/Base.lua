Hooks:PostHook(PlayerManager, "activate_temporary_upgrade", "F_"..Idstring("[KingPin Injector Sound] Gura Scream"):key(), function(self, __var1, __var2)
	if __var1 and __var2 and __var1 == "temporary" and __var2 == "chico_injector" then	
		self:local_player():sound_source():post_event("gawrgurascream0001")
	end
end)