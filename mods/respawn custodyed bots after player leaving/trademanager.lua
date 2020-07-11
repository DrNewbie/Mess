function TradeManager:try_respawn_one_ai_online()
	if not managers.criminals or not Network or not Network:is_server() then
		return
	end
	local __respawn_criminal = nil
	for _, crim in pairs(self._criminals_to_respawn) do
		if crim.ai then
			__respawn_criminal = crim
			break
		end
	end
	if __respawn_criminal then
		local spawn_point = managers.network:session():get_next_spawn_point()
		self:criminal_respawn(spawn_point.pos_rot[1], spawn_point.pos_rot[2], __respawn_criminal)
	end
end