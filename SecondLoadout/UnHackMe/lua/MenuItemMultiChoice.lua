
-- This filters out the "public" entries from the lobby options.
local add_option_original = MenuItemMultiChoice.add_option
function MenuItemMultiChoice:add_option(option)
	if (option._parameters.value ~= "public" and option._parameters.text_id ~= "menu_public_game") then
		add_option_original(self, option)
	end
end
