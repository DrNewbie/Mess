local ThisModPath = ModPath

local __Name = function(__id)
	return "RRR_"..Idstring(tostring(__id).."::"..ThisModPath):key()
end

local is_bool = __Name("is_bool")

if HUDManager and not HUDManager[is_bool] then
	HUDManager[is_bool] = true
	
	local ThisTexture = __Name("need_revive.texture")
	local ThisTexturePath = "guis/"..ThisTexture
	local ThisTexturePathIds = Idstring(ThisTexturePath)

	local ThisTable = __Name("ThisTable")

	Hooks:PostHook(HUDManager, "init", __Name(1), function(self)
		pcall(function()
			BLTAssetManager:CreateEntry( 
				ThisTexturePathIds, 
				Idstring("texture"), 
				ThisModPath.."/need_revive.texture", 
				nil 
			)
			return
		end)
		tweak_data.hud_icons[ThisTexture] = {
			texture = ThisTexturePath,
			texture_rect = {
				1,
				1,
				128,
				128
			}
		}
		self[ThisTable] = self[ThisTable] or {}
	end)

	local function __add_waypoint(ids_key, __unit)
		managers.hud:add_waypoint(
			ids_key,
			{
				icon = ThisTexture,
				distance = false,
				position = __unit:position() + Vector3(0, 0, 50),
				no_sync = true,
				present_timer = 0,
				state = "present",
				radius = 50
			}
		)
		return
	end

	local function __need_help(__u)
		if __u and alive(__u) and __u.character_damage and __u:character_damage() then
			local revive_unit = __u
			local revive_char_dmg_ext = __u:character_damage()
			if (type(revive_unit.interaction) == "function" and revive_unit:interaction() and revive_unit:interaction():active()) or
				(type(revive_char_dmg_ext.need_revive) == "function" and revive_char_dmg_ext:need_revive()) then
				return true
			end
		end
		return false
	end

	local ThisTimeDT = 1

	Hooks:PostHook(HUDManager, "update", __Name(2), function(self, __t, __dt, ...)
		pcall(function()
			ThisTimeDT = ThisTimeDT - __dt
			if ThisTimeDT <= 0 and managers.groupai then
				ThisTimeDT = 1
				local all_criminals = managers.groupai:state():all_char_criminals() or nil
				if type(all_criminals) == "table" then
					for u_key, u_data in pairs(all_criminals) do
						if type(u_data) == "table" and __need_help(u_data.unit) then
							local u_key_ids = __Name(u_key)
							if self[ThisTable][u_key_ids] then
								if self[ThisTable][u_key_ids] ~= u_data.unit then
									self[ThisTable][u_key_ids] = nil
									self:remove_waypoint(u_key_ids)
								end
							else
								self[ThisTable][u_key_ids] = u_data.unit
								__add_waypoint(u_key_ids, u_data.unit)
							end
						end
					end
				end
				for __i, __d in pairs(self[ThisTable]) do
					if not __need_help(__d) then
						self[ThisTable][__i] = nil
						self:remove_waypoint(__i)
					end
				end
			end
		end)
	end)
end

if ReviveInteractionExt and not ReviveInteractionExt[is_bool] then
	ReviveInteractionExt[is_bool] = true
	Hooks:PostHook(ReviveInteractionExt, "set_active", __Name(999), function(self, ...)
		if self._wp_id then
			managers.hud:remove_waypoint(self._wp_id)
		end
	end)
end