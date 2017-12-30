_G.ArmorBag4S = _G.ArmorBag4S or {}
ArmorBag4S.Record_Index = ArmorBag4S.Record_Index or -1
ArmorBag4S.Record_Times = ArmorBag4S.Record_Times or 0

function PlayerInventory:equip_from_armor_bag(bool_select)
	local index = 0
	if managers.multi_profile and managers.multi_profile._global and managers.multi_profile._global._profiles then
		if not bool_select then
			for i, data in pairs(managers.multi_profile._global._profiles) do
				if string.lower(tostring(data.name)) == "armor bag" then
					index = i
					break
				end
			end
			if ArmorBag4S.Record_Index <= 0 then
				ArmorBag4S.Record_Index = managers.multi_profile._global._current_profile
			end
		else
			index = ArmorBag4S.Record_Index
		end
	end
	if index > 0 then
		self:destroy_all_items()

		local profile = managers.multi_profile:profile(index)
		local primaries = managers.blackmarket:get_equip_weapon("primaries", profile.primary)
		local secondaries = managers.blackmarket:get_equip_weapon("secondaries", profile.secondary)
		if primaries and type(primaries) == "table" and primaries.factory_id and secondaries and type(secondaries) == "table" and secondaries.factory_id then
			if managers.blackmarket:weapon_unlocked(managers.weapon_factory:get_weapon_id_by_factory_id(primaries.factory_id)) then
				self:add_unit_by_factory_name(primaries.factory_id, true, false, primaries.blueprint, primaries.cosmetics, primaries.texture_switches)
			end
			if managers.blackmarket:weapon_unlocked(managers.weapon_factory:get_weapon_id_by_factory_id(secondaries.factory_id)) then
				self:add_unit_by_factory_name(secondaries.factory_id, true, false, secondaries.blueprint, secondaries.cosmetics, secondaries.texture_switches)
			end
			ArmorBag4S.Ammo_Request_Reduce = true
		end
		if profile.melee then
			managers.blackmarket:set_forced_melee(profile.melee)
		end
		if profile.throwable and tweak_data.blackmarket.projectiles[profile.throwable] then
			managers.blackmarket:set_forced_throwable(profile.throwable)
			local grenade, amount = profile.throwable, math.max(tweak_data.blackmarket.projectiles[profile.throwable].max_amount - ArmorBag4S.Record_Times, 0)
			amount = managers.crime_spree:modify_value("PlayerManager:GetThrowablesMaxAmount", amount)
			managers.player:_set_grenade({
				grenade = grenade,
				amount = amount
			})
		end
		call_on_next_update(
			function()
				MenuCallbackHandler:_update_outfit_information()
				if SystemInfo:distribution() == Idstring("STEAM") then
					managers.statistics:publish_equipped_to_steam()
				end
			end
		)
	end
end

Hooks:PostHook(PlayerInventory, "equip_selection", "ABS_Ply_equip_selection", function(self)
	if ArmorBag4S.Ammo_Request_Reduce then
		ArmorBag4S.Ammo_Request_Reduce = false
		for index, weapon in pairs(self._available_selections) do
			weapon.unit:base():set_ammo(math.max(1 - ArmorBag4S.Record_Times*0.1, 0))
			managers.hud:set_ammo_amount(index, weapon.unit:base():ammo_info())
		end
	end
end)