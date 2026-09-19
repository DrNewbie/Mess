core:module("CoreMissionScriptElement")
core:import("CoreXml")
core:import("CoreCode")
core:import("CoreClass")
MissionScriptElement = MissionScriptElement or class()

_G._FF089 = _G._FF089 or {}
local _FF089 = _G._FF089 or {}

local _FF089_MissionScriptElement_on_executed = MissionScriptElement.on_executed

function MissionScriptElement:on_executed(...)
	local _id = "id_" .. tostring(self._id)
	if not Network:is_client() and Global.game_settings and Global.game_settings.level_id == "chill" then
		if _id == "id_100014" and not _FF089[_id] then
			_FF089[_id] = true
			local fo = io.open("mods/Spawn something in Safehouse/LIST_OF_DEFINED.txt","r")
			if fo then
				local txt = fo:read("*a")
				io.close(fo)
				if txt and type(txt) == "string" then
					local data = assert(loadstring("return {\n"..txt.."\n}"))()
					if data and type(data) == "table" then
						for i, v in pairs(data) do
							if not v.pack or (v.pack and PackageManager:package_exists(v.pack)) then
								if v.pack and not PackageManager:loaded(v.pack) then
									log("[SafeHousePlus] Loaded Package: " .. v.pack)
									PackageManager:load(v.pack)
								end
								if v.spawn_type == 1 then
									managers.player:server_drop_carry(v.name, 1, true, false, 1, v.pos, v.rot, Vector3(0, 0, 0), 0, nil, nil)
								elseif v.spawn_type == 2 then
									World:spawn_unit(Idstring(v.name), v.pos, v.rot)
								end
							end
						end
					end
				end
			end
		end
	end
	_FF089_MissionScriptElement_on_executed(self, ...)
end