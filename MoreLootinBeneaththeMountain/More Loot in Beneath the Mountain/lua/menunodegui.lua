Hooks:PostHook(MenuNodeGui, "_setup_item_rows", "MoreLootBeneathMountain_MenuNodeGui", function(mis, ...)
	if not Global._friendsonly_warning_shown and Global.game_settings and Global.game_settings.level_id == "pbr" then
		Global._friendsonly_warning_shown = true
		QuickMenu:new(
			"[More Loot in Beneath the Mountain]",
			"Achievmentsis is disabled",
			{
				{
					text = "ok",
					is_cancel_button = true
				}
			},
			true
		)
	end
end)