if not tweak_data.weapon then
else
	local __possible_reload_animations = {}
	for wep_id, wep_data in pairs(tweak_data.weapon) do
		if type(wep_data) == "table" and type(wep_data.animations) == "table" and not table.contains_any(wep_data.categories, {"bow", "crossbow"}) and wep_data.categories[1] ~= "akimbo" and wep_data.weapon_hold then
			__possible_reload_animations[Idstring(wep_data.weapon_hold):key()] = {
				weapon_hold = wep_data.weapon_hold,
				anim_equip_id = wep_data.animations and wep_data.animations.equip_id,
				anim_recoil = wep_data.animations and wep_data.animations.recoil_steelsight
			}
		end
	end	
	Hooks:PostHook(NewRaycastWeaponBase, "start_reload", "F_"..Idstring("NewRaycastWeaponBase:start_reload:Weapon Reload Animations Randomizer"):key(), function(self)
		if __possible_reload_animations then
			local _rnd_this_reload = __possible_reload_animations[table.random_key(__possible_reload_animations)]
			if _rnd_this_reload then
				if _rnd_this_reload.weapon_hold then
					self:weapon_tweak_data().weapon_hold = _rnd_this_reload.weapon_hold
					local PlyStandard = managers.player and managers.player:player_unit() and managers.player:player_unit():movement() and managers.player:player_unit():movement()._states.standard or nil
					if not PlyStandard then
					
					else
						PlyStandard:set_animation_weapon_hold(self:weapon_tweak_data().weapon_hold)
					end
				end
				if _rnd_this_reload.anim_equip_id then
					self:weapon_tweak_data().animations.equip_id = _rnd_this_reload.anim_equip_id
				end
				if _rnd_this_reload.anim_recoil then
					self:weapon_tweak_data().animations.recoil_steelsight = _rnd_this_reload.anim_recoil
				end
			end
		end
	end)
end