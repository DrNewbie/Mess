if CopBrain then
	Hooks:PostHook(CopBrain, "init", "F_"..Idstring("Unmasked Biker Boss::1"):key(), function(self)
		if managers.job and managers.job:current_job_id() == "chew" then
			if self._unit:name():key() == Idstring("units/pd2_dlc_born/characters/ene_gang_biker_boss/ene_gang_biker_boss"):key() then
				local __g_helmet = self._unit:get_object(Idstring("g_helmet"))
				if type(__g_helmet) == "userdata" and type(__g_helmet.set_visibility) == "function" then
					__g_helmet:set_visibility(false)
				end
			end
		end
	end)
end