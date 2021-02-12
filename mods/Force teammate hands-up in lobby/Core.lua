Hooks:PostHook(MenuSceneManager, "set_lobby_character_out_fit", "F_"..Idstring("Force teammate hands-up in lobby"):key(), function(self, i)
	if managers.network:session() and not managers.network:session():peer(i) then
	
	else
		local is_me = i == managers.network:session():local_peer():id()
		if not is_me then
			local unit = self._lobby_characters[i]
			if unit and alive(unit) and unit:damage() then
				unit:play_redirect(Idstring("calibrate"))
			end
		end
	end
end)