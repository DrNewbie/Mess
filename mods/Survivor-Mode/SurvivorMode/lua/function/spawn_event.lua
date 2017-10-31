if Network:is_client() then
	return
end

_G.SurvivorModeBase = _G.SurvivorModeBase or {}

local _f_ElementSpawnEnemyDummy_produce = ElementSpawnEnemyDummy.produce

function ElementSpawnEnemyDummy:produce(params)
	if not managers.groupai:state():is_AI_enabled() then
		return
	end
	if params and params.name and SurvivorModeBase.Spawn_Settings and SurvivorModeBase.Timer_Enable then
		local _key = params.name:key()
		if not SurvivorModeBase.Allow_Spawn_Lists:find(_key) then
			local _settings = SurvivorModeBase.Spawn_Settings
			local _selected = _settings[math.random(#_settings)]
			params.name = Idstring(_selected.enemy)
		end
	end
	return _f_ElementSpawnEnemyDummy_produce(self, params)
end