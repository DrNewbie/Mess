local options_menu = "Challenge_Info"

Hooks:Add("LocalizationManagerPostInit", "Challenge_Info__loc", function(loc)
	LocalizationManager:add_localized_strings({
		["Challenge_Info_menu_title"] = "Challenge Info",
		["Challenge_Info_menu_desc"] = " "
	})
end)

Hooks:Add("MenuManagerSetupCustomMenus", "Challenge_Info_Options", function( menu_manager, nodes )
	MenuHelper:NewMenu(options_menu)
end)

Hooks:Add("MenuManagerPopulateCustomMenus", "Challenge_Info_Options", function( menu_manager, nodes )
		MenuCallbackHandler.Challenge_Info_Callback = function(self, item)
			if not managers.challenge then
				return
			end
			local _text = "There is no challenge right now."
			local _all_active_challenges = managers.challenge:get_all_active_challenges() or {}
			if _all_active_challenges then
				_text = ""
				for _, challenge in pairs(_all_active_challenges) do
					if type(challenge) == "table" and type(challenge.objectives) == "table" and not challenge.objectives.completed then
						if challenge.name_id and (challenge.objective_id or challenge.desc_id) then
							local _challenge_name = managers.localization:to_upper_text(challenge.name_id)
							local _challenge_desc = managers.localization:text((challenge.objective_id or challenge.desc_id))
							_text = _text .. "-- ".. _challenge_name .." --\n".. _challenge_desc .."\n\n"
						end
					end
				end
			end
			local  _tmp = Global.custom_safehouse_manager.daily or {}
			if _tmp and type(_tmp.trophy) == "table" then
				if _tmp.trophy.name_id and (_tmp.trophy.objective_id or _tmp.trophy.desc_id) then
					local _challenge_name = managers.localization:to_upper_text(_tmp.trophy.name_id)
					local _challenge_desc = managers.localization:text((_tmp.trophy.objective_id or _tmp.trophy.desc_id))
					_text = _text .. "-- ".. _challenge_name .." --\n".. _challenge_desc .."\n\n"
				end
			end
			QuickMenu:new("[ Challenge Info ]", _text, {}):Show()
		end
		MenuHelper:AddButton({
			id = "Challenge_Info_Callback",
			title = "Challenge_Info_menu_title",
			desc = "Challenge_Info_menu_desc",
			callback = "Challenge_Info_Callback",
			menu_id = options_menu,
		})
	end)

Hooks:Add("MenuManagerBuildCustomMenus", "Challenge_Info_Options", function(menu_manager, nodes)
	nodes[options_menu] = MenuHelper:BuildMenu(options_menu)
	MenuHelper:AddMenuItem( MenuHelper.menus.lua_mod_options_menu, options_menu, "Challenge_Info_menu_title", "Challenge_Info_menu_desc")
end)