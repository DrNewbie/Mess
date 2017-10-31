if Network:is_client() then
	return
end

_G.SurvivorModeBase = _G.SurvivorModeBase or {}

SurvivorModeBase.Allow_Spawn_Max_Amount = {}

SurvivorModeBase.Allow_Spawn_Lists = ""

function SurvivorModeBase:Load_Wave_Spawn_Settings()
	local _Allow_Spawn_Lists = {}
	local _Allow_Spawn_Max_Amount = {}
	for k, v in pairs(SurvivorModeBase.Spawn_Settings or {}) do
		local _key = Idstring(v.enemy):key()
		table.insert(_Allow_Spawn_Lists, _key)
		_Allow_Spawn_Max_Amount[_key] = v.max_amount
	end
	SurvivorModeBase.Allow_Spawn_Max_Amount = deep_clone(_Allow_Spawn_Max_Amount)
	SurvivorModeBase.Allow_Spawn_Lists = tostring(json.encode(_Allow_Spawn_Lists))
	_Allow_Spawn_Max_Amount = {}
	_Allow_Spawn_Lists = {}
end

function SurvivorModeBase:Check_Before_Do(game, wave)
	if not game or not tweak_data or not tweak_data.levels or not tweak_data.levels[game] then
		return false
	end
	local file_name = "mods/SurvivorMode/wave/".. game .."/wave_".. wave ..".txt"
	local file = io.open(file_name, "r")
	if not file then
		return false
	end
	return true
end

function SurvivorModeBase:Write_New_GroupAITweakData(game, wave)
	if not game or not tweak_data or not tweak_data.levels or not tweak_data.levels[game] then
		return -- Undefined Game
	end
	if not wave or wave <= 0 then
		wave = 1
	end
	local file_name = "mods/SurvivorMode/wave/".. game .."/wave_".. wave ..".txt"
	local file = io.open(file_name, "r")
	if not file then
		return -- No defiend wave setting
	end
	local _date = {}
	local line = file:read()
	local _txt = tostring(line)
	while line do
		_date[#_date+1] = _txt
		line = file:read()
		_txt = tostring(line)
	end	
	file:close()	
	file_name = "mods/SurvivorMode/lua/override/groupaitweakdata.lua"
	local file = io.open(file_name, "w")
	if not file then
		return false
	end
	for _, data in pairs(_date) do
		file:write("" .. data, "\n")
	end
	file:close()
	dofile(file_name)
	SurvivorModeBase:Load_Wave_Spawn_Settings()
	SurvivorModeBase.Time_for_Next_Wave = false
end

function SurvivorModeBase:Change_To_Next_Wave(game, wave, time)
	if SurvivorModeBase:Check_Before_Do(game, wave) then
		DelayedCalls:Add( "DelayedCalls_WaveChangeIn10", time, function()
			SurvivorModeBase:talk2all("[System] Wave is going to change in 10s")
			SurvivorModeBase:Write_New_GroupAITweakData(game, wave)
			SurvivorModeBase.Load = false
		end)
	end
end

function SurvivorModeBase:Create_Empty_One()
	file_name = "mods/SurvivorMode/lua/override/groupaitweakdata.lua"
	local file = io.open(file_name, "w")
	if file then
		file:write(" ")
		file:close()
	end
end