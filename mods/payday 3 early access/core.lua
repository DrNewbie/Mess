local function __FakeVersion()
	return [[Payday 3 (stylised as PAYDAY 3) is an upcoming first-person shooter game developed by 
Overkill Software and Starbreeze Studios and published by Prime Matter, as a sequel 
to Payday 2 from the same series. On December 31, a teaser trailer revealing its logo 
was released. The game will take place after the ending of Payday 2 where the heisters 
went separate ways and left their lives of crime, but something is to re-motivate 
the Payday Gang to continue crime. The original crew of characters originating from 
Payday: The Heist ("Dallas", "Chains", "Wolf", and "Hoxton") will be in Payday 3, and 
the game will take place mainly in New York. The first mission will take place at 
the "Gold & Sharke Incorporated" bank. Payday 3 will take place in the 2020s, 
intended to add more depth to the Payday Gang's crimes with game-changing differences 
like more advanced surveillance or the rise of cryptocurrency. Publisher Starbreeze 
Studios announced in May 2016 that Payday 3 was in development at Overkill Software, 
after Starbreeze acquired the rights to the intellectual property for around US$30 
million. In March 2021, Koch Media committed to pay €50 million to assist in the game's 
development and marketing, including more than 18 months of post-launch support using 
the games as a service model. Payday 3 will be developed using Unreal Engine. 
The game is planned to release in 2023.]]
end

local function __Name(__text)
	return "PD3_feb20aa7d527bb96_"..tostring(__text)
end

local function __init(ws)
	if not ws and managers.gui_data and managers.gui_data:create_fullscreen_16_9_workspace() then
		ws = managers.gui_data:create_fullscreen_16_9_workspace():panel()
	end
	if not ws then
		return
	end
	if _G.__pd3_super_awesome_ad and alive(_G.__pd3_super_awesome_ad) then
		_G.__pd3_super_awesome_ad:parent():remove(_G.__pd3_super_awesome_ad)
		_G.__pd3_super_awesome_ad = nil
	end
	local __version = __FakeVersion()
	_G.__pd3_super_awesome_ad = ws:panel():text({
		name = "pd3_version_string",
		vertical = "top",
		align = "center",
		alpha = 1,
		text = __version,
		color = Color.green,
		font = "fonts/font_large_mf",
		font_size = 42,
		visible = true,
		layer = 10000
	})
	return
end

if MenuSceneManager and not _G[__Name("MenuSceneManager")] then
	_G[__Name("MenuSceneManager")] = true
	Hooks:PostHook(MenuSceneManager, "_setup_gui", __Name("1"), function(...)
		pcall(__init)
	end)
end

if not _G[__Name("MenuManagerOnOpenMenu")] then
	_G[__Name("MenuManagerOnOpenMenu")] = true
	Hooks:Add("MenuManagerOnOpenMenu", __Name("2"), function(self, menu)
		pcall(__init)
	end)
end

if LevelLoadingScreenGuiScript and not _G[__Name("LevelLoadingScreenGuiScript")] then
	Hooks:PostHook(LevelLoadingScreenGuiScript, "init", __Name("3"), function(self)
	_G[__Name("LevelLoadingScreenGuiScript")] = true
		pcall(__init, self._back_drop_gui:get_new_base_layer())
	end)
end

if MenuPauseRenderer and not _G[__Name("MenuPauseRenderer")] then
	_G[__Name("MenuPauseRenderer")] = true
	Hooks:PostHook(MenuPauseRenderer, "open", __Name("4"), function(self)
		pcall(__init, self._fullscreen_panel)
	end)
end

if LightLoadingScreenGuiScript and not _G[__Name("LightLoadingScreenGuiScript")] then
	_G[__Name("LightLoadingScreenGuiScript")] = true
	Hooks:PostHook(LightLoadingScreenGuiScript, "init", __Name("5"), function(self)
		pcall(__init, self._ws)
	end)
end

if MenuCallbackHandler and not _G[__Name("MenuCallbackHandler")] then
	_G[__Name("MenuCallbackHandler")] = true
	Hooks:PostHook(MenuCallbackHandler, "change_resolution", __Name("6"), function(self)
		pcall(__init)
	end)
end