_G.Skins2All = _G.Skins2All or {}

local _skins2all_get_weapon_icon_path = BlackMarketManager.get_weapon_icon_path

function BlackMarketManager:get_weapon_icon_path(weapon_id, cosmetics)
	local _texture_path, _rarity_path = _skins2all_get_weapon_icon_path(self, weapon_id, cosmetics)
	if type(_texture_path) == 'string' and _texture_path:find('skins2all') then
		if Skins2All.populate_weapon_cosmetics then
			local datas = string.split(_texture_path, '_skins2all_')
			_texture_path = datas[1]
		else
			_texture_path, _ = _skins2all_get_weapon_icon_path(self, weapon_id)
		end
	end
	return _texture_path, _rarity_path
end

local _skins2all_tradable_update = false

function BlackMarketManager:tradable_update()
	if _skins2all_tradable_update then
		return
	end
	_skins2all_tradable_update = true
	local _weapon_skins = tweak_data.blackmarket.weapon_skins or {}	 
	local _i = 1
	for _id, _data in pairs(_weapon_skins) do
		if _id:find('skins2all') then
			while self._global.inventory_tradable[_i] ~= nil do
				_i = _i + 1
			end
			if not self:have_inventory_tradable_item("weapon_skins", _id) then
				self:tradable_add_item(_i, "weapon_skins", _id, "mint", true, 1)
			end
		end
	end
end