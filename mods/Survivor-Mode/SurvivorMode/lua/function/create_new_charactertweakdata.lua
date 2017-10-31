if Network:is_client() then
	return
end

_G.SurvivorModeBase = _G.SurvivorModeBase or {}

function SurvivorModeBase:Write_New_CharacterTweakData(game)
	if not game or not tweak_data or not tweak_data.levels or not tweak_data.levels[game] then
		return -- Undefined Game
	end
	local file_name = "mods/SurvivorMode/wave/".. game .."/boss.txt"
	local file = io.open(file_name, "r")
	if not file then
		return -- No defiend setting
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
	file_name = "mods/SurvivorMode/lua/override/charactertweakdata.lua"
	local file = io.open(file_name, "w")
	if not file then
		return false
	end
	--SurvivorModeBase:Sync_Send("Sync_NEW_CharacterTweakData", "START")
	for _, data in pairs(_date) do
		file:write("" .. data, "\n")
		--SurvivorModeBase:Sync_Send("Sync_NEW_CharacterTweakData", "" .. data, "\n")
	end
	--SurvivorModeBase:Sync_Send("Sync_NEW_CharacterTweakData", "END")
	file:close()
end