_G.MaskWhitelistF = _G.MaskWhitelistF or {}

local _MaskWhitelistF_MenuSceneManaset_character_mask_by_id = MenuSceneManager.set_character_mask_by_id

function MenuSceneManager:set_character_mask_by_id(mask_id, blueprint, unit, peer_id)
	if mask_id and MaskWhitelistF.Whitelist and MaskWhitelistF.Whitelist[mask_id] == 0 then
		local _name = tostring(managers.blackmarket:get_real_character(mask_id, peer_id))
		local _data = {}
		_data = MaskWhitelistF:Check(_name, {mask_id = mask_id, mask_obj = ""})
		if _data and _data.mask_id and _data.mask_obj then
			mask_id = _data.mask_id
		end
	end
	return _MaskWhitelistF_MenuSceneManaset_character_mask_by_id(self, mask_id, blueprint, unit, peer_id)
end