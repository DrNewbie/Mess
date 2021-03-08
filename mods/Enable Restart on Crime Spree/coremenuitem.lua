core:module("CoreMenuItem")

Item = Item or class()
Item.TYPE = "item"

Hooks:PreHook(Item, "set_callback_handler", "F_"..Idstring("Enable Restart on Crime Spree:Item:set_callback_handler"):key(), function(self)
	if type(self._visible_callback_name_list) == "table" then
		if self:name() == "restart_game" then
			self._visible_callback_name_list = {"singleplayer_restart"}
		elseif self:name() == "restart_level" then
			self._visible_callback_name_list = {"restart_level_visible"}
		elseif self:name() == "restart_vote" then
			self._visible_callback_name_list = {"restart_vote_visible"}
		elseif self:name() == "abort_mission" then
			self._visible_callback_name_list = {"abort_mission_visible"}
		elseif self:name() == "end_game" then
			self._visible_callback_name_list = {"is_not_editor"}
		end
	end
end)