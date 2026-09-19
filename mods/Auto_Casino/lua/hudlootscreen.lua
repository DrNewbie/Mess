local _f_begin_choose_card = HUDLootScreen.begin_choose_card
function HUDLootScreen:begin_choose_card(peer_id, ...)
	_f_begin_choose_card(self, peer_id, ...)
	self._peer_data[peer_id].wait_t = 0
end