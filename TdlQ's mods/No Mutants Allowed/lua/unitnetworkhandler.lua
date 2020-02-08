local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local nma_original_unitnetworkhandler_syncupgrade = UnitNetworkHandler.sync_upgrade
function UnitNetworkHandler:sync_upgrade(upgrade_category, upgrade_name, upgrade_level, sender)
	nma_original_unitnetworkhandler_syncupgrade(self, upgrade_category, upgrade_name, upgrade_level, sender)

	local peer = self._verify_sender(sender)
	if peer then
		NoMA:CheckUpgrade(peer, nil, upgrade_category, upgrade_name, upgrade_level)
	end
end

local nma_original_unitnetworkhandler_playdistanceinteractredirect = UnitNetworkHandler.play_distance_interact_redirect
function UnitNetworkHandler:play_distance_interact_redirect(unit, redirect, sender)
	nma_original_unitnetworkhandler_playdistanceinteractredirect(self, unit, redirect, sender)

	if not alive(unit) or not self._verify_gamestate(self._gamestate_filter.any_ingame) then
		return
	end
	local peer = self._verify_sender(sender)
	if not peer then
		return
	end

	if redirect == 'cmd_get_up' then
		NoMA:CheckUpgrade(peer, 'cooldown_long_dis_revive')
		NoMA:CheckInspireCooldown(peer)
	end
end

local nma_original_unitnetworkhandler_syncteammateprogress = UnitNetworkHandler.sync_teammate_progress
function UnitNetworkHandler:sync_teammate_progress(type_index, enabled, tweak_data_id, timer, success, sender)
	local peer = self._verify_sender(sender)
	if not self._verify_gamestate(self._gamestate_filter.any_ingame) or not peer then
		return
	end

	if enabled then -- start
		NoMA:InitTimer(peer, tweak_data_id, timer)
	elseif success then -- completed
		NoMA:CheckElapsedTime(peer, tweak_data_id)
	end

	nma_original_unitnetworkhandler_syncteammateprogress(self, type_index, enabled, tweak_data_id, timer, success, sender)
end

local nma_original_unitnetworkhandler_syncinteracted = UnitNetworkHandler.sync_interacted
function UnitNetworkHandler:sync_interacted(unit, unit_id, tweak_setting, status, sender)
	if not self._verify_gamestate(self._gamestate_filter.any_ingame) then
		return
	end
	local peer = self._verify_sender(sender)
	if not peer then
		return
	end

	NoMA:CheckInteraction(peer, tweak_setting, unit, unit_id)

	nma_original_unitnetworkhandler_syncinteracted(self, unit, unit_id, tweak_setting, status, sender)
end

local nma_original_unitnetworkhandler_syncequipmentsetup = UnitNetworkHandler.sync_equipment_setup
function UnitNetworkHandler:sync_equipment_setup(unit, upgrade_lvl, peer_id)
	if not alive(unit) or not self._verify_gamestate(self._gamestate_filter.any_ingame) then
		return
	end
	nma_original_unitnetworkhandler_syncequipmentsetup(self, unit, upgrade_lvl, peer_id)

	local ub = unit:base()
	if ub then
		local peer = managers.network:session():peer(peer_id)

		if ub._max_amount and upgrade_lvl == 1 then
			NoMA:CheckUpgrade(peer, 'doctor_bag_amount_increase1')

		elseif ub._battery_life then
			if upgrade_lvl == 2 then
				NoMA:CheckUpgrade(peer, 'ecm_jammer_duration_multiplier')
			elseif upgrade_lvl >= 3 then
				NoMA:CheckUpgrade(peer, 'ecm_jammer_duration_multiplier_2')
			end

		elseif ub._damage_reduction_upgrade then
			NoMA:CheckUpgrade(peer, 'first_aid_kit_damage_reduction_upgrade')
		end
	end
end

local function check_ammobag(peer, upgrade_lvl, bullet_storm_level)
	if upgrade_lvl == 1 then
		NoMA:CheckUpgrade(peer, 'ammo_bag_ammo_increase1')
	end

	if bullet_storm_level == 1 then
		NoMA:CheckUpgrade(peer, 'temporary_no_ammo_cost_1')
	elseif bullet_storm_level > 1 then
		NoMA:CheckUpgrade(peer, 'temporary_no_ammo_cost_2')
	end
end

local nma_original_unitnetworkhandler_syncammobagsetup = UnitNetworkHandler.sync_ammo_bag_setup
function UnitNetworkHandler:sync_ammo_bag_setup(unit, upgrade_lvl, peer_id, bullet_storm_level)
	nma_original_unitnetworkhandler_syncammobagsetup(self, unit, upgrade_lvl, peer_id, bullet_storm_level)

	local peer = managers.network:session():peer(peer_id)
	if peer then
		check_ammobag(peer, upgrade_lvl, bullet_storm_level)
	end
end

local nma_original_unitnetworkhandler_placeammobag = UnitNetworkHandler.place_ammo_bag
function UnitNetworkHandler:place_ammo_bag(pos, rot, upgrade_lvl, bullet_storm_level, rpc)
	local peer = self._verify_sender(rpc)
	if not self._verify_gamestate(self._gamestate_filter.any_ingame) or not peer then
		return
	end

	nma_original_unitnetworkhandler_placeammobag(self, pos, rot, upgrade_lvl, bullet_storm_level, rpc)

	check_ammobag(peer, upgrade_lvl, bullet_storm_level)
end

local nma_original_unitnetworkhandler_placedeployablebag = UnitNetworkHandler.place_deployable_bag
function UnitNetworkHandler:place_deployable_bag(class_name, pos, rot, upgrade_lvl, rpc)
	local peer = self._verify_sender(rpc)
	if not self._verify_gamestate(self._gamestate_filter.any_ingame) or not peer then
		return
	end

	nma_original_unitnetworkhandler_placedeployablebag(self, class_name, pos, rot, upgrade_lvl, rpc)

	if class_name == 'DoctorBagBase' and upgrade_lvl == 1 then
		NoMA:CheckUpgrade(peer, 'doctor_bag_amount_increase1')

	elseif class_name == 'FirstAidKitBase' and upgrade_lvl == 1 then
		NoMA:CheckUpgrade(peer, 'first_aid_kit_damage_reduction_upgrade')
	end
end

local nma_original_unitnetworkhandler_syncammoamount = UnitNetworkHandler.sync_ammo_amount
function UnitNetworkHandler:sync_ammo_amount(selection_index, max_clip, current_clip, current_left, max, sender)
	local peer = self._verify_sender(sender)
	if not self._verify_gamestate(self._gamestate_filter.any_ingame) or not peer then
		return
	end

	-- selection_index may be wrong thanks to all functions using "id" instead of "weapon.unit:base():selection_index()"
	if selection_index == 2 then
		local infos = managers.player._global.synced_ammo_info[peer:id()]
		if infos then
			local info = infos[selection_index]
			if info then
				if info[1] ~= max_clip or info[4] ~= max then
					local next_info = infos[selection_index + 1]
					if next_info and next_info[1] == max_clip and next_info[4] == max then
						selection_index = selection_index + 1
					end
				end
			end
		end
	end

	nma_original_unitnetworkhandler_syncammoamount(self, selection_index, max_clip, current_clip, current_left, max, sender)

	NoMA:CheckAmmo(peer, selection_index, max_clip, current_clip, current_left, max)
end

local nma_original_unitnetworkhandler_syncsmallloottaken = UnitNetworkHandler.sync_small_loot_taken
function UnitNetworkHandler:sync_small_loot_taken(unit, multiplier_level, sender)
	local peer = self._verify_sender(sender)
	if not alive(unit) or not self._verify_gamestate(self._gamestate_filter.any_ingame) or not peer then
		return
	end
	nma_original_unitnetworkhandler_syncsmallloottaken(self, unit, multiplier_level, sender)

	if multiplier_level > 0 then
		NoMA:CheckUpgrade(peer, 'player_small_loot_multiplier_' .. multiplier_level)
	end
end

local nma_original_unitnetworkhandler_longdisinteraction = UnitNetworkHandler.long_dis_interaction
function UnitNetworkHandler:long_dis_interaction(target_unit, amount, aggressor_unit, secondary)
	if not self._verify_gamestate(self._gamestate_filter.any_ingame) or not self._verify_character(target_unit) or not self._verify_character(aggressor_unit) then
		return
	end

	nma_original_unitnetworkhandler_longdisinteraction(self, target_unit, amount, aggressor_unit, secondary)

	local target_is_criminal = target_unit:in_slot(managers.slot:get_mask('criminals')) or target_unit:in_slot(managers.slot:get_mask('harmless_criminals'))
	local aggressor_is_criminal = aggressor_unit:in_slot(managers.slot:get_mask('criminals')) or aggressor_unit:in_slot(managers.slot:get_mask('harmless_criminals'))
	if target_is_criminal and aggressor_is_criminal and amount == 1 and not target_unit:brain() then
		local peer = managers.network:session():peer_by_unit(aggressor_unit)
		NoMA:CheckUpgrade(peer, 'player_morale_boost')
	end
end

local nma_original_unitnetworkhandler_synccarrydata = UnitNetworkHandler.sync_carry_data
function UnitNetworkHandler:sync_carry_data(unit, carry_id, carry_multiplier, dye_initiated, has_dye_pack, dye_value_multiplier, position, dir, throw_distance_multiplier_upgrade_level, zipline_unit, peer_id, sender)
	if not alive(unit) or not self._verify_gamestate(self._gamestate_filter.any_ingame) or not self._verify_sender(sender) then
		return
	end
	nma_original_unitnetworkhandler_synccarrydata(self, unit, carry_id, carry_multiplier, dye_initiated, has_dye_pack, dye_value_multiplier, position, dir, throw_distance_multiplier_upgrade_level, zipline_unit, peer_id, sender)

	if throw_distance_multiplier_upgrade_level == 1 then
		local peer = peer_id == 0 and self._verify_sender(sender) or managers.network:session():peer(peer_id)
		NoMA:CheckUpgrade(peer, 'carry_throw_distance_multiplier')
	end
end

local nma_original_unitnetworkhandler_serverunlockasset = UnitNetworkHandler.server_unlock_asset
function UnitNetworkHandler:server_unlock_asset(asset_id, is_show_chat_message, sender)
	local peer = self._verify_sender(sender)
	if not self._verify_gamestate(self._gamestate_filter.any_ingame) or not peer then
		return
	end
	nma_original_unitnetworkhandler_serverunlockasset(self, asset_id, is_show_chat_message, sender)

	-- remove restriction once http://steamcommunity.com/app/218620/discussions/14/1480982338949858824/ gets integrated
	if asset_id ~= 'bodybags_bag' or not table.contains(tweak_data.assets.bodybags_bag.stages, Global.game_settings.level_id) then
		local asset = tweak_data.preplanning.types[asset_id]
		if asset and asset.upgrade_lock then
			NoMA:CheckUpgrade(peer, asset.upgrade_lock.category .. '_' .. asset.upgrade_lock.upgrade)
		end
	end
end
tweak_data.assets.bodybags_bag.server_lock = nil

local nma_original_unitnetworkhandler_syncunlockasset = UnitNetworkHandler.sync_unlock_asset
function UnitNetworkHandler:sync_unlock_asset(asset_id, is_show_chat_message, unlocker_peer_id, sender)
	if not self._verify_gamestate(self._gamestate_filter.any_ingame) or not self._verify_sender(sender) then
		return
	end
	local peer = managers.network:session():peer(unlocker_peer_id)
	nma_original_unitnetworkhandler_syncunlockasset(self, asset_id, is_show_chat_message, unlocker_peer_id, sender)

	local asset = tweak_data.preplanning.types[asset_id]
	if asset and asset.upgrade_lock then
		NoMA:CheckUpgrade(peer, asset.upgrade_lock.category .. '_' .. asset.upgrade_lock.upgrade)
	end
end

local nma_original_unitnetworkhandler_synctripminesetup = UnitNetworkHandler.sync_trip_mine_setup
-- TODO test
function UnitNetworkHandler:sync_trip_mine_setup(unit, sensor_upgrade, peer_id)
	nma_original_unitnetworkhandler_synctripminesetup(self, unit, sensor_upgrade, peer_id)

	if sensor_upgrade then
		NoMA:CheckUpgrade(managers.network:session():peer(peer_id), 'trip_mine_sensor_toggle')
	end
end

local nma_original_unitnetworkhandler_requestplaceecmjammer = UnitNetworkHandler.request_place_ecm_jammer
function UnitNetworkHandler:request_place_ecm_jammer(battery_life_upgrade_lvl, body, rel_pos, rel_rot, rpc)
	local peer = self._verify_sender(rpc)
	if not self._verify_gamestate(self._gamestate_filter.any_ingame) or not peer then
		return
	end

	nma_original_unitnetworkhandler_requestplaceecmjammer(self, battery_life_upgrade_lvl, body, rel_pos, rel_rot, rpc)

	if battery_life_upgrade_lvl == 2 then
		NoMA:CheckUpgrade(peer, 'ecm_jammer_duration_multiplier')
	elseif battery_life_upgrade_lvl >= 3 then
		NoMA:CheckUpgrade(peer, 'ecm_jammer_duration_multiplier_2')
	end
end

local nma_original_unitnetworkhandler_sethealth = UnitNetworkHandler.set_health
function UnitNetworkHandler:set_health(unit, percent, max_mul, sender)
	local peer = self._verify_sender(sender)
	if not alive(unit) or not self._verify_gamestate(self._gamestate_filter.any_ingame) or not peer then
		return
	end
	nma_original_unitnetworkhandler_sethealth(self, unit, percent, max_mul, sender)

	local profile = NoMA:GetPlayerProfile(peer)
	if percent == 0 and profile.previous_armor_pct == 0 and unit:movement()._state ~= 'bleed_out' then
		profile.time_of_death = TimerManager:game():time()
	end
	profile.previous_health_pct = percent
end

local nma_original_unitnetworkhandler_setarmor = UnitNetworkHandler.set_armor
function UnitNetworkHandler:set_armor(unit, percent, max_mul, sender)
	if not alive(unit) or not self._verify_gamestate(self._gamestate_filter.any_ingame) or not self._verify_sender(sender) then
		return
	end
	nma_original_unitnetworkhandler_setarmor(self, unit, percent, max_mul, sender)

	local peer = self._verify_sender(sender)
	NoMA:CheckArmor(peer, percent)
end

local nma_original_unitnetworkhandler_syncplayermovementstate = UnitNetworkHandler.sync_player_movement_state
function UnitNetworkHandler:sync_player_movement_state(unit, state, down_time, unit_id_str)
	if not alive(unit) or not self._verify_gamestate(self._gamestate_filter.any_ingame) then
		return
	end
	nma_original_unitnetworkhandler_syncplayermovementstate(self, unit, state, down_time, unit_id_str)

	local local_peer = managers.network:session():local_peer()
	local local_unit = local_peer:unit()
	if local_unit and unit:key() ~= local_unit:key() then
		local profile, peer = NoMA:GetPlayerProfileByUnit(unit)
		if peer then
			if state == 'tased' then
				profile.time_tased = TimerManager:game():time()

			elseif state == 'bleed_out' then
				local now = TimerManager:game():time()
				profile.time_of_death = profile.time_of_death or now
				local swan_time = now - profile.time_of_death
				if NoMA.timespeedchange_t > profile.time_of_death then
					-- qued
				elseif swan_time > tweak_data.upgrades.values.temporary.berserker_damage_multiplier[1][2] * 0.9 then
					if swan_time < tweak_data.upgrades.values.temporary.berserker_damage_multiplier[2][2] * 0.9 or profile.time_tased > profile.time_of_death then
						NoMA:CheckUpgrade(peer, 'temporary_berserker_damage_multiplier_1')
					else
						NoMA:CheckUpgrade(peer, 'temporary_berserker_damage_multiplier_2')
					end
				end

				profile.time_of_death = nil
			end
		end
	end
end

local mark_enemy_damage_bonus_id, mark_enemy_damage_bonus_distance_id
if ContourExt then
	for i, name in pairs(ContourExt.indexed_types) do
		if name == 'mark_enemy_damage_bonus' then
			mark_enemy_damage_bonus_id = i
		elseif name == 'mark_enemy_damage_bonus_distance' then
			mark_enemy_damage_bonus_distance_id = i
		end
	end
end

local nma_original_unitnetworkhandler_synccontourstate = UnitNetworkHandler.sync_contour_state
function UnitNetworkHandler:sync_contour_state(unit, u_id, typ, state, multiplier, sender)
	nma_original_unitnetworkhandler_synccontourstate(self, unit, u_id, typ, state, multiplier, sender)

	if typ == mark_enemy_damage_bonus_id then
		local peer = self._verify_sender(sender)
		if peer then
			NoMA:CheckUpgrade(peer, 'player_marked_enemy_extra_damage')
		end

	elseif typ == mark_enemy_damage_bonus_distance_id then
		local peer = self._verify_sender(sender)
		if peer then
			NoMA:CheckUpgrade(peer, 'player_marked_inc_dmg_distance_1')
		end
	end
end

local nma_original_unitnetworkhandler_synctripmineexplodespawnfire = UnitNetworkHandler.sync_trip_mine_explode_spawn_fire
function UnitNetworkHandler:sync_trip_mine_explode_spawn_fire(unit, user_unit, ray_from, ray_to, damage_size, damage, added_time, range_multiplier, sender)
	nma_original_unitnetworkhandler_synctripmineexplodespawnfire(self, unit, user_unit, ray_from, ray_to, damage_size, damage, added_time, range_multiplier, sender)

	local peer = self._verify_sender(sender)
	if peer then
		local fire_trap1 = tweak_data.upgrades.values.trip_mine.fire_trap[1]
		if math.abs(added_time - fire_trap1[1]) < 0.01 and math.abs(range_multiplier - fire_trap1[2]) < 0.01 then
			NoMA:CheckUpgrade(peer, 'trip_mine_fire_trap_1')
		else
			NoMA:CheckUpgrade(peer, 'trip_mine_fire_trap_2')
		end
	end
end

local nma_original_unitnetworkhandler_synccocainestacks = UnitNetworkHandler.sync_cocaine_stacks
function UnitNetworkHandler:sync_cocaine_stacks(amount, in_use, upgrade_level, power_level, sender)
	nma_original_unitnetworkhandler_synccocainestacks(self, amount, in_use, upgrade_level, power_level, sender)

	local peer = self._verify_sender(sender)
	if peer then
		if upgrade_level > 1 then
			NoMA:CheckUpgrade(peer, 'player_sync_cocaine_upgrade_level_1')
		else
			NoMA:CheckUpgrade(peer, 'player_sync_cocaine_stacks')
		end
	end
end

local nma_original_unitnetworkhandler_damagesimple = UnitNetworkHandler.damage_simple
function UnitNetworkHandler:damage_simple(subject_unit, attacker_unit, damage, i_attack_variant, i_result, death, sender)
	nma_original_unitnetworkhandler_damagesimple(self, subject_unit, attacker_unit, damage, i_attack_variant, i_result, death, sender)

	if i_attack_variant == 5 then
		local peer = self._verify_sender(sender)
		if peer then
			NoMA:CheckUpgrade(peer, 'snp_graze_damage_1')
		end
	end
end

local nma_original_unitnetworkhandler_damagemelee = UnitNetworkHandler.damage_melee
function UnitNetworkHandler:damage_melee(subject_unit, attacker_unit, damage, damage_effect, i_body, height_offset, variant, death, sender)
	if variant == 4 and not alive(attacker_unit) then
		local peer = self._verify_sender(sender)
		if peer then
			NoMA:CheckUpgrade(peer, 'player_counter_strike_melee')
		end
	end
	nma_original_unitnetworkhandler_damagemelee(self, subject_unit, attacker_unit, damage, damage_effect, i_body, height_offset, variant, death, sender)
end
