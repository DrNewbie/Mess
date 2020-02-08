local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local fs_original_weaponfactorymanager_getstats = WeaponFactoryManager.get_stats
function WeaponFactoryManager:get_stats(factory_id, blueprint)
	self.fs_stats_cache = self.fs_stats_cache or {}
	local cache_key = factory_id .. table.concat(blueprint)
	local result = self.fs_stats_cache[cache_key]
	if result then
		return clone(result)
	end

	result = fs_original_weaponfactorymanager_getstats(self, factory_id, blueprint)
	self.fs_stats_cache[cache_key] = result
	return clone(result)
end

local fs_original_weaponfactorymanager_hasperk = WeaponFactoryManager.has_perk
function WeaponFactoryManager:has_perk(perk_name, factory_id, blueprint)
	self.fs_perk_cache = self.fs_perk_cache or {}

	local cache_key = perk_name .. factory_id .. table.concat(blueprint)
	local result = self.fs_perk_cache[cache_key]
	if result ~= nil then
		return result
	end

	result = fs_original_weaponfactorymanager_hasperk(self, perk_name, factory_id, blueprint)
	self.fs_perk_cache[cache_key] = result
	return result
end

local fs_original_weaponfactorymanager_getperkstats = WeaponFactoryManager.get_perk_stats
function WeaponFactoryManager:get_perk_stats(perk_name, factory_id, blueprint)
	self.fs_perkstats_cache = self.fs_perkstats_cache or {}

	local cache_key = perk_name .. factory_id .. table.concat(blueprint)
	local result = self.fs_perkstats_cache[cache_key]
	if result ~= nil then
		return result
	end

	result = fs_original_weaponfactorymanager_getperkstats(self, perk_name, factory_id, blueprint)
	self.fs_perkstats_cache[cache_key] = result
	return result
end

local fs_original_weaponfactorymanager_unpackblueprintfromstring = WeaponFactoryManager.unpack_blueprint_from_string
function WeaponFactoryManager:unpack_blueprint_from_string(factory_id, ...)
	if not factory_id or type(tweak_data.weapon.factory[factory_id]) ~= 'table' then
		return
	end

	return fs_original_weaponfactorymanager_unpackblueprintfromstring(self, factory_id, ...)
end

DelayedCalls:Add('DelayedModFSS_getfactoryidbyweaponid', 0, function()
	local w2f = {}
	for _, data in pairs(tweak_data.upgrades.definitions) do
		if data.category == 'weapon' then
			w2f[data.weapon_id] = data.factory_id
		end
	end

	function WeaponFactoryManager:get_factory_id_by_weapon_id(weapon_id)
		return w2f[weapon_id]
	end
end)
