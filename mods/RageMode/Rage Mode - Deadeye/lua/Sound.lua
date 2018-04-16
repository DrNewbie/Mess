if not ModCore then
	log("[ERROR] BeardLib is not installed!")
	return
else	
	local movie_ids = Idstring("movie")
	function PlayerManager:PlaySpecialSound(sound)
		if not PackageManager:has(movie_ids, Idstring(sound)) then
			return
		end
		local p = managers.menu_component._main_panel
		if not p then
			return
		end
		local name = "injectorsound"..sound
		if alive(p:child(name)) then
			p:remove(p:child(name))
		end		
		p:video({
			name = name,
			video = sound,
			visible = false,
			loop = true,
		}):set_volume_gain(0.1)
		return name, 0.1
	end
end