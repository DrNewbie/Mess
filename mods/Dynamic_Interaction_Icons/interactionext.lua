local ThisModSeed = "trip_mine"
local ThisModPath = ModPath
local ThisModAssetsPath = ThisModPath .. "/assets/units/gui"
local ThisModOldTexturePath = ThisModAssetsPath .. "/old_c4_indicator_df.texture"
local ThisModAltTexturePath = ThisModAssetsPath .. "/red_c4_indicator_df.texture"
local ThisModUseTexturePath = ThisModAssetsPath .. "/c4_indicator_df.texture"

local ThisModIds = "F_"..Idstring(ThisModSeed..'::managers.player:can_pickup_equipment("c4")'):key()
local ThisModIds_dt = "F_"..Idstring(ThisModIds..':dt'):key()
_G[ThisModIds] = _G[ThisModIds] or {}
_G[ThisModIds_dt] = _G[ThisModIds_dt] or nil

local function C4TextureChanger(on_off)
	if CustomPackageManager then
		if io.file_is_readable(ThisModUseTexturePath) then
			os.remove(ThisModUseTexturePath)
		end
		SystemFS:copy_file((on_off and ThisModAltTexturePath or ThisModOldTexturePath), ThisModUseTexturePath)
		_G[ThisModIds_dt] = 2
	end
end

Hooks:PostHook(BaseInteractionExt, "init", "F_"..Idstring("PostHook:BaseInteractionExt:init:"..ThisModIds..":OwO"):key(), function(self)
	if managers.player then
		local is_c4 = managers.player:get_equipment_amount("trip_mine", 2) <= 1 and true or false
		if _G[ThisModIds] ~= is_c4 then
			_G[ThisModIds] = is_c4
			C4TextureChanger(is_c4)
		end
	end
end)

Hooks:PostHook(BaseInteractionExt, "interact", "F_"..Idstring("PostHook:BaseInteractionExt:interact:"..ThisModIds..":OwO"):key(), function(self)
	if managers.player then
		local is_c4 = managers.player:get_equipment_amount("trip_mine", 2) <= 1 and true or false
		if _G[ThisModIds] ~= is_c4 then
			_G[ThisModIds] = is_c4
			C4TextureChanger(is_c4)
		end
	end
end)

Hooks:Add("GameSetupUpdate", "F_"..Idstring("Hooks:Add:GameSetupUpdate:"..ThisModIds..":OwO"):key(), function(t, dt)
	if not managers.player or not managers.player:player_unit() or not _G[ThisModIds_dt] then
	
	else
		_G[ThisModIds_dt] = _G[ThisModIds_dt] - dt
		if _G[ThisModIds_dt] < 0 then
			_G[ThisModIds_dt] = nil
			if io.file_is_readable(ThisModUseTexturePath) then
				CustomPackageManager:LoadPackageConfig(ThisModPath.."assets/", {{
					_meta = "texture",
					path = "units/gui/c4_indicator_df",
					force = true
				}})
			end
		end
	end
end)