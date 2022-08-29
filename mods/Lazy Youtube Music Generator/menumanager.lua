_G.LazyYoutubeMusicGeneratorMain = _G.LazyYoutubeMusicGeneratorMain or {}
_G.LazyYoutubeMusicGeneratorMain.ModPath = _G.LazyYoutubeMusicGeneratorMain.ModPath or ModPath
_G.LazyYoutubeMusicGeneratorMain.MenuID = "LazyYoutubeMusicGeneratorMenuID"

Hooks:Add("MenuManagerSetupCustomMenus", "LazyYoutubeMusicGeneratorSetup", function(menu_manager, nodes)
	MenuHelper:NewMenu(_G.LazyYoutubeMusicGeneratorMain.MenuID)
end)

Hooks:Add("MenuManagerBuildCustomMenus", "LazyYoutubeMusicGeneratorBuild", function(menu_manager, nodes)
	nodes[_G.LazyYoutubeMusicGeneratorMain.MenuID] = MenuHelper:BuildMenu(_G.LazyYoutubeMusicGeneratorMain.MenuID)
	MenuHelper:AddMenuItem(nodes["blt_options"], _G.LazyYoutubeMusicGeneratorMain.MenuID, "menu_LazyYoutubeMusicGenerator_name", "menu_LazyYoutubeMusicGenerator_desc")
end)

Hooks:Add("MenuManagerPopulateCustomMenus", "LazyYoutubeMusicGeneratorPopulate", function(menu_manager, nodes)
	MenuCallbackHandler.RunLazyYoutubeMusicGeneratorFunc = function()
		local __clipboard = Application:get_clipboard()
		__clipboard = tostring(__clipboard)
		local vidid1 = string.match(__clipboard, "v=(...........)")
		local vidid2 = string.match(__clipboard, "youtu.be/(...........)")
		local vidid_now
		if vidid1 then
			vidid_now = vidid1
		elseif vidid2 then
			vidid_now = vidid2
		end
		local menu_title = managers.localization:text("menu_LazyYoutubeMusicGenerator_name")
		local menu_message = managers.localization:text("menu_LazyYoutubeMusicGenerator_menu_msgs")
		menu_message = menu_message:gsub('%$yturl%$', vidid_now)
		local menu_options = {
			[1] = {
				text = managers.localization:text("menu_LazyYoutubeMusicGenerator_menu_yes"),
				callback = function()
					QuickMenu:new(
						menu_title,
						managers.localization:text("menu_LazyYoutubeMusicGenerator_menu_downloading"),
						{
							{
								text = managers.localization:text("menu_LazyYoutubeMusicGenerator_menu_close"),
								is_cancel_button = true
							}
						}
					):Show()
					pcall(_G.LazyYoutubeMusicGeneratorMain.Download, vidid_now)
					QuickMenu:new(
						menu_title,
						managers.localization:text("menu_LazyYoutubeMusicGenerator_menu_download_ok"),
						{
							{
								text = managers.localization:text("menu_LazyYoutubeMusicGenerator_menu_close"),
								is_cancel_button = true
							}
						}
					):Show()
				end
			},
			[2] = {
				text = managers.localization:text("menu_LazyYoutubeMusicGenerator_menu_show"),
				callback = function()
					Steam:overlay_activate("url", "https://youtu.be/"..vidid_now)
				end,
			},
			[3] = {
				text = managers.localization:text("menu_LazyYoutubeMusicGenerator_menu_close"),
				is_cancel_button = true
			}
		}
		local menu = QuickMenu:new(menu_title, menu_message, menu_options)
		menu:Show()
	end
	MenuHelper:AddButton({
		id = "RunLazyYoutubeMusicGenerator",
		title = "menu_LazyYoutubeMusicGenerator_name",
		desc = "menu_LazyYoutubeMusicGenerator_desc",
		callback = "RunLazyYoutubeMusicGeneratorFunc",
		menu_id = _G.LazyYoutubeMusicGeneratorMain.MenuID
	})
end)