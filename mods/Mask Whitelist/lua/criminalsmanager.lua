_G.MaskWhitelistF = _G.MaskWhitelistF or {}

function CriminalsManager:character_data_by_name(name)
	for _, data in pairs(self._characters) do
		if data.taken and name == data.name then
			return MaskWhitelistF:Check(name, data.data)
		end
	end
end