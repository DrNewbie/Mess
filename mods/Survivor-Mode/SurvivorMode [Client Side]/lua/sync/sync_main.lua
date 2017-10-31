if not Network:is_client() then
	return
end

_G.SurvivorMode_Client_Base = _G.SurvivorMode_Client_Base or {}

SurvivorMode_Client_Base.Version = "beta.5"

Hooks:Add("NetworkReceivedData", "NetworkReceivedData_SurvivorMode_Client", function(sender, sync_asked, data)
	if sync_asked and data then
		if sync_asked == "Sync_No_Return_Timer" then
			data = data or 0
			local time = tonumber(data) or 0
			managers.groupai:state():set_point_of_no_return_timer(time, 0)
		end
		if sync_asked == "Sync_Announce_Now_Wave" then
			data = data or 0
			local wave = tonumber(data) or 0
			DelayedCalls:Add( "DelayedCallsExample", 10, function()
				managers.hud:show_hint({text = "Wave: [".. wave .."]"})
			end )
		end
		if sync_asked == "SurvivorMode_Sync_Check" then
			data = tostring(data)
			if data == SurvivorMode_Client_Base.Version then
				SurvivorMode_Client_Base:Sync_Send("SurvivorMode_Sync_Check_Ans", 2, 1)
			else
				SurvivorMode_Client_Base:Sync_Send("SurvivorMode_Sync_Check_Ans", 1, 1)
			end
		end
		if sync_asked == "Sync_Load_Packages" then
			data = data:gsub(",,,", "/")
			log("[SurvivorMode_Client]: Sync_Load_Packages , ".. data)
			if not PackageManager:loaded(data) and PackageManager:package_exists(data) then
				PackageManager:load(data)
			end
			if data == "START" then
				SurvivorMode_Client_Base.NEW_Load_Packages = {
					"local _missino_init_orig = MissionManager.init",
					"function MissionManager:init(...)",
					"_missino_init_orig(self, ...)",
				}
			elseif data == "END" then
				local _List = SurvivorMode_Client_Base.NEW_Load_Packages
				SurvivorMode_Client_Base.NEW_Load_Packages[#_List+1] = "end\n"
				SurvivorMode_Client_Base:Write_NEW_Load_Packages(SurvivorMode_Client_Base.NEW_Load_Packages)
				SurvivorMode_Client_Base.NEW_Load_Packages = {}
			else
				local _List = SurvivorMode_Client_Base.NEW_Load_Packages
				SurvivorMode_Client_Base.NEW_Load_Packages[#_List+1] = "	if not PackageManager:loaded(\"".. data .."\") and PackageManager:package_exists(\"".. data .."\") then"
				SurvivorMode_Client_Base.NEW_Load_Packages[#_List+1] = "		PackageManager:load(\"".. data .."\")"
				SurvivorMode_Client_Base.NEW_Load_Packages[#_List+1] = "	end"
			end
		end
		if sync_asked == "Sync_NEW_CharacterTweakData" then
			data = tostring(data)
			if data == "START" then
				SurvivorMode_Client_Base.NEW_CharacterTweakData = {}
			elseif data == "END" then
				SurvivorMode_Client_Base:Write_New_CharacterTweakData(SurvivorMode_Client_Base.NEW_CharacterTweakData)
				SurvivorMode_Client_Base.NEW_CharacterTweakData = {}
			else
				local _List = SurvivorMode_Client_Base.NEW_CharacterTweakData
				SurvivorMode_Client_Base.NEW_CharacterTweakData[#_List+1] = data
			end
		end
	end
end)

function SurvivorMode_Client_Base:Sync_Send(Sync_asked, data, peer_id)
	_Net = _G and _G.LuaNetworking or nil
	if _Net then
		if not peer_id then
			_Net:SendToPeers(Sync_asked, data)
		else
			_Net:SendToPeer(peer_id, Sync_asked, data)
		end
	else
		log("[SurvivorModeBase]: Sync_Send Fail. '".. Sync_asked .."'")
	end
end