local ThisModMain = _G.MetalSlugGameModeMIds
_G[ThisModMain] = _G[ThisModMain] or {}
local M_Func = _G[ThisModMain]

Hooks:PostHook(PlayerManager, "on_killshot", M_Func.NameIds("PlayerManager::on_killshot"), function(self, __killed_unit)
	if M_Func.Is_Running then
		local player_unit = self:player_unit()
		if not M_Func.Is_True or not player_unit or CopDamage.is_civilian(__killed_unit:base()._tweak_table) then
		
		else
			call_on_next_update(function ()
				local wep_unit = M_Func.SpawnGun(
					Idstring("units/payday2/weapons/wpn_npc_ak47/wpn_npc_ak47"),
					__killed_unit:position() + Vector3(0, 0, 100),
					nil
				)
				if wep_unit then
					local __data = {
						t = 10,
						touch_dis = 150,
						touch_func = function()
							if M_Func.Is_Xaudio then
								M_Func.PlaySound("announce_heavy_machine_gun.ogg")
							end
							local PlyStandard = self:player_unit() and self:player_unit():movement() and self:player_unit():movement()._states.standard or nil
							if PlyStandard then
								local __weapon_id = "ak74"
								local __factory_id = "wpn_fps_ass_74"
								local __data = {
									__type = ThisModMain,
									weapon_id = __weapon_id,
									factory_id = __factory_id,
									blueprint = tweak_data.weapon.factory[__factory_id].default_blueprint,
									selection_wanted = tweak_data.weapon[__weapon_id].use_data.selection_index,
									ammo_max = 30,
									ammo_total = 30,
									ammo_max_per_clip = 30,
									ammo_remaining_in_clip = 30
								}
								PlyStandard[M_Func.NameIds("PlayerStandard::func1")](PlyStandard, __data)
							end
						end
					}
					M_Func.InsetUnitsToCheck(wep_unit, __data)
				end
			end)
		end
	end
end)