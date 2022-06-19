_G.EEArmorBuffMain = _G.EEArmorBuffMain or {}
_G.EEArmorBuffMain.ThisModPath = ModPath
_G.EEArmorBuffMain.ThisModIds = Idstring(_G.EEArmorBuffMain.ThisModPath):key()
_G.EEArmorBuffMain.__Name = function(__id)
	return "EEAB_"..Idstring(tostring(__id).."::".._G.EEArmorBuffMain.ThisModIds):key()
end