
-- show warning at startup
local _setup_item_rows_original = MenuNodeGui._setup_item_rows
function MenuNodeGui:_setup_item_rows(node, ...)
	_setup_item_rows_original(self, node, ...)
	if not Global._friendsonly_warning_shown then
		Global._friendsonly_warning_shown = true
		QuickMenu:new(
			"[All Painting were Stealable]",
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
end
