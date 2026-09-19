Hooks:PostHook(CrimeSpreeManager, "init", "MoreGageAsset_Init", function(self, ...)
	self._has_unlocked_asset_count = 0
end)

tweak_data.crime_spree.max_assets_unlocked = 999

function CrimeSpreeManager:unlock_gage_asset(asset_id)	
	local asset_tweak_data = tweak_data.crime_spree.assets[asset_id]
	managers.crime_spree:new_asset_tweak_data_cost(asset_id)

	if not asset_tweak_data then
		return false
	end

	if not self:can_unlock_asset() then
		return false
	end

	if not self:_can_asset_be_unlocked(asset_id) then
		return false
	end
	
	managers.custom_safehouse:deduct_coins(asset_tweak_data.cost)

	local params = {
		CrimeSpreeManager.GageAssetEvents.Unlock,
		asset_id
	}
	managers.network:session():send_to_peers("sync_crime_spree_gage_asset_event", unpack(params))
	self._has_unlocked_asset_count = self._has_unlocked_asset_count + 1
	self._has_unlocked_asset = false
	self:_on_asset_unlocked(asset_id)	
	return true
end

function CrimeSpreeManager:get_unlocked_asset_count()
	return self._has_unlocked_asset_count
end

function CrimeSpreeManager:new_asset_tweak_data_cost(asset_id)
	local asset_tweak_data = tweak_data.crime_spree.assets[asset_id]
	if not asset_tweak_data then
		return 0
	end
	local asset_tweak_data_cost = asset_tweak_data.cost
	if self._has_unlocked_asset_count > 0 then
		asset_tweak_data_cost = asset_tweak_data_cost*math.round(1.3*self._has_unlocked_asset_count)
		tweak_data.crime_spree.assets[asset_id].cost = asset_tweak_data_cost
	end
	return asset_tweak_data_cost
end