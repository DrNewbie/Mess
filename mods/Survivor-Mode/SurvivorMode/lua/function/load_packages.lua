if Network:is_client() then
	return
end

_G.SurvivorModeBase = _G.SurvivorModeBase or {}

SurvivorModeBase.Asked_From = {}

function SurvivorModeBase:Load_Package(where)
	if SurvivorModeBase and where and SurvivorModeBase.Asked_From[where] == true then
		return
	end
	if where then
		SurvivorModeBase.Asked_From[where] = true
	end
	local _packages = SurvivorModeBase.PackageRequired or {}
	SurvivorModeBase:Sync_Send("Sync_Load_Packages", "START")
	for _, v in pairs(_packages) do
		if not PackageManager:loaded(v) then
			PackageManager:load(v)
		end
		local _escape_v = v:gsub("/", ",,,")
		SurvivorModeBase:Sync_Send("Sync_Load_Packages", _escape_v)
	end
	SurvivorModeBase:Sync_Send("Sync_Load_Packages", "END")
	return
end