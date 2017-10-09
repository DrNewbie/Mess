_G.AutoCasino = _G.AutoCasino or {}
AutoCasino.init = AutoCasino.init or false
AutoCasino.secure_cards = AutoCasino.secure_cards or 0
AutoCasino.increase_infamous = AutoCasino.increase_infamous or false
AutoCasino.preferred_card = AutoCasino.preferred_card or "none"

local _f_place_bet = CrimeNetCasinoGui._place_bet
function CrimeNetCasinoGui:_place_bet()
	local secure_cards, increase_infamous, preferred_card = self:_crimenet_casino_additional_cost()
	if not AutoCasino.init then
		AutoCasino.init = true
		AutoCasino.secure_cards = secure_cards
		AutoCasino.increase_infamous = increase_infamous
		AutoCasino.preferred_card = preferred_card
		AutoCasino.start_offshore = 
		_f_place_bet(self)
		return
	end
	secure_cards = AutoCasino.secure_cards or 0
	increase_infamous = AutoCasino.increase_infamous or false
	preferred_card = AutoCasino.preferred_card or "none"
	if not managers.money:can_afford_casino_fee(secure_cards, increase_infamous, preferred_card) then
		return
	end
	if managers.menu:active_menu().logic:selected_node():item("preferred_item") then
		managers.money:_deduct_from_offshore(managers.money:get_cost_of_casino_fee(secure_cards, increase_infamous, preferred_card))
		managers.menu:active_menu().renderer:selected_node():set_offshore_text()
		local node_data = {}
		node_data.preferred_item = preferred_card
		node_data.secure_cards = secure_cards
		node_data.increase_infamous = increase_infamous
		node_data.back_callback = callback(self, self, "_crimenet_casino_lootdrop_back")
		managers.menu:open_node("crimenet_contract_casino_lootdrop", {node_data})
	end
end

local _f_can_afford = CrimeNetCasinoGui.can_afford
function CrimeNetCasinoGui:can_afford()
	_f_can_afford(self)
	if AutoCasino.init then
		self:_place_bet()
	end
end