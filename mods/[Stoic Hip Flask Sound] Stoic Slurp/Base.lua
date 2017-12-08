if not ModCore then
	log("[ERROR] BeardLib is not installed!")
	return
else
	StoicSlurp = StoicSlurp or ModCore:new(ModPath .. "Config.xml", true, true)
	
	tweak_data.blackmarket.projectiles.damage_control.sounds.activate = {
		cooldown = "perkdeck_cooldown_over"
	}
	
	local Use_attempt_damage_control = PlayerManager.add_grenade_amount
	function PlayerManager:add_grenade_amount(amount, sync)
		if amount == -1 and managers.blackmarket:equipped_grenade() == "damage_control" then
			StoicSlurp:Play("UseStoicSlurp")
		end
		Use_attempt_damage_control(self, amount, sync)
	end
	
	local movie_ids = Idstring("movie")
	function StoicSlurp:Play(sound)
		if not self.Options:GetValue("On"..sound) then
			return
		end
		if not PackageManager:has(movie_ids, Idstring(sound)) then
			return
		end
		local p = managers.menu_component._main_panel
		local name = "StoicSlurp"..sound
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