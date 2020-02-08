local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

_G.FullSpeedSwarm = _G.FullSpeedSwarm or {}
FullSpeedSwarm._path = ModPath
FullSpeedSwarm._data_path = SavePath .. 'full_speed_swarm.txt'
FullSpeedSwarm.in_arrest_logic = {}
FullSpeedSwarm.units_per_navseg = {}
FullSpeedSwarm.call_on_loud = {}
FullSpeedSwarm.custom_mutators = {}
FullSpeedSwarm.final_settings = {}
FullSpeedSwarm.settings = {
	task_throughput = 600,
	walking_quality = 1,
	lod_updater = 1,
	optimized_inputs = true,
	fastpaced = false,
	iter_chase = false,
	nervous_game = false,
	custom_assault = true,
	cop_awareness = false,
	spawn_delay = true,
	slower_but_safer = false, -- to be enabled in mods/saves/full_speed_swarm.txt
	real_elastic = false,
	tie_stamina_to_lives = false
}

function FullSpeedSwarm:UpdateWalkingQuality()
	CopBase.fs_lod_stage = CopBase['fs_lod_stage_' .. self.settings.walking_quality]
end

function FullSpeedSwarm:GetGameplayOptionsForcedValues()
	local result = {}

	if not Iter then
		result.iter_chase = false
	end

	if self.settings.real_elastic then
		result.cop_awareness = true
		result.custom_assault = true
		result.fastpaced = true
		result.iter_chase = true
		result.nervous_game = true
		result.tie_stamina_to_lives = true
	end

	return result
end

function FullSpeedSwarm:CalcMaxTaskThroughput()
	local gstate = managers and managers.groupai and managers.groupai:state()
	if not gstate or not gstate._tweak_data then
		return 600
	end

	local force = gstate:_get_difficulty_dependent_value(gstate._tweak_data.assault.force)
	local force_balance_mul = gstate._tweak_data.assault.force_balance_mul[4]
	return math.ceil(force * force_balance_mul) * 7
end

function FullSpeedSwarm:UpdateMaxTaskThroughput()
	if self.settings.task_throughput ~= 0 then
		return
	end
	if type(FullSpeedSwarm.UpdateMaxTaskThroughputLocally) ~= 'function' then
		return
	end
	local new_value = self:CalcMaxTaskThroughput()
	FullSpeedSwarm:UpdateMaxTaskThroughputLocally(new_value)
	log('[FSS] max task throughput set to ' .. tostring(new_value))
end

function FullSpeedSwarm:FinalizeSettings()
	for k in pairs(self.final_settings) do
		self.final_settings[k] = nil
	end

	for k, v in pairs(self.settings) do
		self.final_settings[k] = v
	end

	for k, v in pairs(self:GetGameplayOptionsForcedValues()) do
		self.final_settings[k] = v
	end
end

function FullSpeedSwarm:Load()
	local file = io.open(self._data_path, 'r')
	if file then
		for k, v in pairs(json.decode(file:read('*all')) or {}) do
			self.settings[k] = v
		end
		file:close()
	end
	self:FinalizeSettings()
end

function FullSpeedSwarm:Save()
	local settings = clone(self.settings)
	settings.real_elastic = nil
	local file = io.open(self._data_path, 'w+')
	if file then
		file:write(json.encode(settings))
		file:close()
	end
end

FullSpeedSwarm:Load()

core:module('CoreCode')

if _G.FullSpeedSwarm.settings.slower_but_safer then
	function alive(obj)
		local tp = type(obj)
		if tp == 'userdata' or tp == 'table' and type(obj.alive) == 'function' then
			return obj:alive()
		end
		return false
	end
else
	function alive(obj)
		return obj and obj:alive()
	end
end
