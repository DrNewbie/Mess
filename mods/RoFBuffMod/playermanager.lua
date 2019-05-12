function PlayerManager:Set_Rof_Buff_Addon(num)
	self._Rof_Buff_Addon = num
end

function PlayerManager:Get_Rof_Buff_Addon()
	return self._Rof_Buff_Addon or 1
end