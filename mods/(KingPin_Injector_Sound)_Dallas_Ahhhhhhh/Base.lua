if not ModCore then
	log("[ERROR] BeardLib is not installed!")
	return
else
	InjectorSound = InjectorSound or ModCore:new(ModPath .. "Config.xml", true, true)
	
	tweak_data.blackmarket.projectiles.chico_injector.sounds.activate = {
		cooldown = "perkdeck_cooldown_over"
	}
	
	local Use_attempt_chico_injector = PlayerManager._attempt_chico_injector
	function PlayerManager:_attempt_chico_injector()
		local Ans = Use_attempt_chico_injector(self)
		if Ans then
			InjectorSound:Play("UseInjectorSound")
		end
		return Ans
	end
	
	local movie_ids = Idstring("movie")
	function InjectorSound:Play(sound)
		if not self.Options:GetValue("On"..sound) then
			return
		end
		if not PackageManager:has(movie_ids, Idstring(sound)) then
			return
		end
		local p = managers.menu_component._main_panel
		local name = "injectorsound"..sound
		if alive(p:child(name)) then
			managers.menu_component._main_panel:remove(p:child(name))
		end		
		local volume = managers.user:get_setting("sfx_volume")
		local percentage = (volume - tweak_data.menu.MIN_SFX_VOLUME) / (tweak_data.menu.MAX_SFX_VOLUME - tweak_data.menu.MIN_SFX_VOLUME)
		managers.menu_component._main_panel:video({
			name = name,
			video = sound,
			visible = false,
			loop = false,
		}):set_volume_gain(percentage)
	end
end