function TeamAIInventory:set_min_equipment(equipment)
	self._min_equipment = equipment
	self._min_equipment_amount = 4
end

function TeamAIInventory:min_equipment()
	return self._min_equipment
end

function TeamAIInventory:reduce_min_equipment_amount()
	self._min_equipment_amount = self._min_equipment_amount - 1
end

function TeamAIInventory:min_equipment_amount()
	return self._min_equipment_amount
end