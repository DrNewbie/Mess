local _hts_PlayerInventory_init = PlayerInventory.init

function PlayerInventory:init(...)
	_hts_PlayerInventory_init(self, ...)
	self._shield_unit = nil
end

local _hts_PlayerInventory_place_selection = PlayerInventory._place_selection

function PlayerInventory:_place_selection(selection_index, is_equip)
	_hts_PlayerInventory_place_selection(self, selection_index, is_equip)
	if not self:is_this_able_to_shield() then
		return
	end
	if selection_index == 2 and is_equip then
		self:give_shield()
	else
		self:hide_shield()
	end
end

function PlayerInventory:get_shield_unit()
	return self._shield_unit
end

function PlayerInventory:check_shield_unit()
	return self._shield_unit and alive(self._shield_unit) and true or false
end

function PlayerInventory:give_shield()
	if not self:is_this_able_to_shield() then
		return
	end
	self:hide_shield()
	if self:equipped_unit():base().AKIMBO then
		self:equipped_unit():base():give_shield()
	end
end

function PlayerInventory:hide_shield()
	if not self:is_this_able_to_shield() then
		return
	end
	self:set_shield_unit()
end

function PlayerInventory:set_shield_unit(_shield_unit)
	if not self:is_this_able_to_shield() then
		return
	end
	if self._shield_unit and alive(self._shield_unit) then
		self._shield_unit:unlink()
		World:delete_unit(self._shield_unit)
	end
	self._shield_unit = _shield_unit
end

function PlayerInventory:is_this_able_to_shield()
	local peer = managers.network:session():peer_by_unit(self._unit)
	if peer and peer == managers.network:session():local_peer() then
		return true
	end
	return false
end