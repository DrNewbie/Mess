local mod_ids = Idstring("Use parachute to avoid fall death"):key()
local is_bool = "__is_"..mod_ids
local is_loaded = PackageManager:loaded("packages/narr_jerry2")

if PlayerStandard then
	Hooks:PreHook(PlayerStandard, "_update_foley", "F_"..Idstring("_update_foley:"..mod_ids):key(), function(self)
		if self._state_data.on_zipline then
		
		else
			if self._state_data.in_air then
				local __height = self._state_data.enter_air_pos_z - self._pos.z
				if __height >= 599 then
					if not is_loaded then
						managers.player[is_bool] = true
					end
					managers.player:set_player_state("jerry2")
				end
			end
		end
	end)
end

if IngameParachuting then
	local __old_IngameParachuting_at_exit = IngameParachuting.at_exit
	function IngameParachuting:at_exit(...)
		if managers.player[is_bool] then
			managers.player[is_bool] = false
			local player = managers.player:player_unit()
			if player then
				player:base():set_enabled(false)
			end
			managers.hud:hide(PlayerBase.PLAYER_INFO_HUD)
			managers.hud:hide(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN)
			return
		end
		__old_IngameParachuting_at_exit(self, ...)
	end
end