dofile(FullSpeedSwarm._path .. 'mutators/mutatorbigparty.lua')
dofile(FullSpeedSwarm._path .. 'mutators/mutatorrealelastic.lua')

local fs_original_mutatorsmanager_init = MutatorsManager.init
function MutatorsManager:init()
	fs_original_mutatorsmanager_init(self)

	for _, custom_mutator in pairs(FullSpeedSwarm.custom_mutators) do
		table.insert(self._mutators, custom_mutator:new(self))

		local id = custom_mutator._type
		local data = Global.mutators.active_on_load[id]
		if data then
			local mutator = self:get_mutator_from_id(id)
			table.insert(self:active_mutators(), {mutator = mutator})

			for key, value in pairs(data) do
				if Network:is_client() then
					mutator:set_host_value(key, value)
				end
			end

			mutator:setup(self)
		end
	end
end

local fs_original_mutatorsmanager_setenabled = MutatorsManager.set_enabled
function MutatorsManager:set_enabled(mutator, enabled)
	if enabled == nil then
		enabled = true
	end

	if enabled then
		if type(mutator) == 'string' then
			mutator = self:get_mutator_from_id(mutator)
		end
		if mutator and mutator._type == 'MutatorRealElastic' then
			if Iter then
				Iter.settings.streamline_path = true
				Iter:Save()
			else
				enabled = false
				local title = managers.localization:text('blt_mod_missing_dependency', {dependency='Iter'})
				local message = managers.localization:text('blt_mod_missing_dependencies')
				QuickMenu:new(title, message, {}, true)
			end
		end
	end

	return fs_original_mutatorsmanager_setenabled(self, mutator, enabled)
end
